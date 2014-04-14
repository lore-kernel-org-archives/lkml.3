Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaDNTUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:20:25 -0400
Received: from mail3.nrl.navy.mil ([132.250.4.27]:39879 "EHLO
	mail3.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaDNTUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:20:22 -0400
X-Greylist: delayed 1630 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 15:20:21 EDT
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] tuntap: add flow control to support back pressure
From: Brian Adamson <Brian.Adamson@nrl.navy.mil>
In-Reply-To: <20140414054031.GA15088@redhat.com>
Date: Mon, 14 Apr 2014 14:45:52 -0400
Cc: Steven Galgano <sgalgano@adjacentlink.com>, davem@davemloft.net,
        jasowang@redhat.com, xemul@parallels.com, wuzhy@linux.vnet.ibm.com,
        therbert@google.com, yamato@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joseph Giovatto <jgiovatto@adjacentlink.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <52C1DB14-81A2-473E-B455-92B20D8D9C0B@nrl.navy.mil>
References: <5345FFBC.7020502@adjacentlink.com> <20140410102931.GA12077@redhat.com> <5347487B.4040608@adjacentlink.com> <34F30F7A-5AEF-4E7B-9513-7A008CEE8820@nrl.navy.mil> <20140413141418.GA17839@redhat.com> <534B39D3.8040804@adjacentlink.com> <20140414054031.GA15088@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

I really appreciate your time in helping us dive into this issue.  

Below, you had suggested to "limit the speed of tun interface using a non work conserving disc" and matching the rate of the backend device.  Unfortunately, many backend devices (whether real devices or ones we are emulating), do not have a fixed bit rate.  For example, multiple access devices like WiFi get back pressure from the Layer 2 channel contention when there are many neighbors sharing the wireless channel at once and the rate of transmission is somewhat unpredictable (other than the upper bound according to your wireless card rate).  A physical device, like a Wifi card, usually has a limited number of packets it enqueues within the device and provides "back pressure" to the IP stack (and hence the associated qdisc for that interface and sockets that are sending packets via that interface) when its device queue is full and waiting for channel access.  This type of behavior is what we would at least like to have the option to mirror with a tuntap device and have been doing successfully until the change in the behavior with the more recent kernels.  

With Steve Galgano's patch, I'm going to do some more testing, including with multiple virtual interfaces and multiple traffic classes from multiple sockets, etc.

Meanwhile, one simple test case I have conducted (both with the non-patched and patched tuntap code) is to instantiate a virtual interface where the user space process is reading packets from the kernel at a limited rate (hence creating "back pressure").  I have a traffic generator using two different sockets generate UDP packets for two different traffic classes (0x00 and 0x10 (i.e. normal and priority pfifo_fast bands) at a rate somewhat higher than the rate at which packets are consumed from tap device.  With this generator, "pairs" of UDP packets (one from each socket / priority band) are  sent via the tap interface.  In my test case, it happens to be that in the "pairs" of packets, the lower priority packet hits the tap device first, followed by the higher priority packet.  With the current Linux non-patched (no flow control) tap device, I actually get a pathological situation where, when there's a slot open in the tap device queue, the first arriving "low priority" packet of the pair gets it and the second arriving "high priority" packet always gets dropped.  With the patched driver that provides back pressure flow control, the priority qdisc gets enforced properly with the high priority traffic making it through and the low priority packets being dropped by the qdisc.  

As you mention below, I suppose this is because with the non-patched tun driver, it never gets "stopped" and nothing is ever queued in the "qdisc".  I'm not sure that is desirable behavior? This was a simple test case with a single tap device.  As mentioned, I am going to carefully examine the behavior with multiple virtual interfaces, etc.  In my past experience, I don't think I have seen a problem where a tap device that is being limited or blocked by its user space process has affected packets being routed to _other_ interfaces, including other tap devices?  I could see that being the case for a single UDP tx socket that is sending packets to different destinations and possibly routed out different interfaces, although   I can try that case, too.  

Generally, I have assumed that individual virtual interfaces behaved the same as physical interfaces with regards to flow control based on how the underlying device driver (or user space code in the case of a tap device) consumed packets enqueued to the interface.  So, I'm not yet 100% understanding some of the concerns you have expressed with regards to the tap device differ from the same case with a physical device, but I will do more testing.


On Apr 14, 2014, at 1:40 AM, Michael S. Tsirkin <mst@redhat.com> wrote:

> On Sun, Apr 13, 2014 at 09:28:51PM -0400, Steven Galgano wrote:
>> On 04/13/2014 10:14 AM, Michael S. Tsirkin wrote:
>>> 
>>> Steven, Brian,
>>> 
>>> thanks for reporting this issue.
>>> Please see my comments below.
>>> 
>>> On Fri, Apr 11, 2014 at 12:41:42PM -0400, Brian Adamson wrote:
>>>> To weigh in on the desire to have support (at least as an optional behavior) for the legacy flow control behavior, there are many existing uses of it.  Many these are related to experimental purposes where the tuntap driver can be used (with a little user space code) as a surrogate for a network interface type that may not even yet exist.  And in some cases these experimental purposes have had utility for actual deployment (e.g. disaster relief wireless networks where  the TAP device has provided some intermediate assistance for routing or other protocols, even an underwater acoustic sensor network proposed for reef monitoring, etc where a TAP device provides a network interface and the sound card is used as a modem on an embedded system).  Some of these networks have low data rates or packet loss and delays that make TCP (which provides flow control as part of its usual reliable transport for more typical networking purpose) not an ideal protocol to use and so UDP or oth!
>> er alterna
>> tives or used.  To keep this short, I'll list a few use cases here I know (and was involved with the implementation of some) with some links (where I know them):
>>>> 
>>>> 1) CORE network emulation tool  (http://code.google.com/p/coreemu/)
>>>> 
>>>> 2) EMANE network emulation tool (https://github.com/adjacentlink/emane)
>>>> 
>>>> (likely other network emulation tools exist that have used tuntap as surrogates for real physical interfaces and expect the same backpressure to sockets and queues that physical interfaces provide)
>>>> 
>>>> 3) I don't have a link to it but I implemented an experimental IP interface/ MAC protocol called SLIDE (serial-link internet daemon) that implemented a user-space CSMA MAC protocol where an underwater acoustic modem was connected to the serial port and TAP was used to present a virtual network interface to the IP stack.  Because of the low data rates involved, the back pressure flow control to application sockets (and protocol daemons and qdiscs applied)  was important.
>>>> 
>>>> 4)  User space implementation of Simplified Multicast Forwarding (SMF) of RFC 6621 has a "device" option that establishes TAP interfaces to perform distributed "backpressure" based flow control (and potentially routing) for MANET wireless networks.  (http://www.nrl.navy.mil/itd/ncs/products/smf)
>>>> 
>>>> There are probably some more, among the more esoteric wireless and other special networking communities, where host (or routing/gateway/proxy non-host), e.g. special embedded system devices based on Linux such as sensors, etc) have a first hop network attachment that is _not_ the typical Ethernet or something and may be using tuntap along with a sort of user-space "driver" to present an IP interface to the network stack. some of this stuff, especially embedded systems, tend to lag behind with respect to kernel versions and this behavior change in Linux may be yet undiscovered so far even though the change was put in a couple years ago.
>>>> 
>>>> Several of these are implemented across multiple platforms, and, for example, BSD-based systems tuntap provides the same flow control behavior.  Even if it was never formally documented, I think this behavior was fairly well known (at least for these sorts of experimental purposes) and used.  I understand the concern that a single bad behaving flow can possibly block the flow of others unless traffic control queuing disciplines (as done for other network interfaces).  For the purposes of which I'm aware, I think having this behavior as _optional_ is probably OK … If accepted, and something is implemented here, it may be a good opportunity to have it documented (and the pros and cons of its use) for the more general Linux community.
>>> 
>>> Yes, a UDP socket with sufficiently deep qdisc and tun queues
>>> would previously get slowed down so it matches the speed of
>>> the interface.
>>> 
>>> But IIUC this was not really designed to be a flow control measure,
>>> so depending on what else is in the qdisc you could easily get
>>> into a setup where it behaves exactly as it does now.
>>> For example, have several UDP sockets send data out a single
>>> interface.
>>> 
>>> Another problem is that this depends on userspace to be
>>> well-behaved and consume packets in a timely manner:
>>> a misbehaving userspace operating a tun device can cause other
>>> tun devices and/or sockets to get blocked forever and prevent them
>>> from communicating with all destinations (not just the misbehaving one)
>>> as their wmem limit is exhausted.
>>> 
>>> It should be possible to reproduce with an old kernel and your userspace
>>> drivers, too - just stop the daemon temporarily.
>>> I realize that your daemon normally is well-behaved, and
>>> simply moves all incoming packets to the backend without
>>> delay, but I'd like to find a solution that addresses
>>> this without trusting userspace to be responsive.
>>> 
>>> 
>>> 
>>> 
>>> At the moment, for this use-case it's possible to limit the speed of tun
>>> interface using a non work conserving qdisc.  Make that match the speed
>>> of the backend device, and you get back basically the old behaviour
>>> without the security problem in that the rate is basically ensured
>>> by kernel and all packets queued are eventually consumed.
>>> 
>>> Does this solve the problem for you?
>>> 
>>> 
>> I do not believe this solves the problem.
>> 
>> The issue is with what happens when a queue is full. When multiqueue
>> support was introduced, the tun went from stopping the queue to dropping
>> packets.
> 
> This actually happened previously too on qdisc queue overrun.
> 
>> In the back pressure use case, the application code using the character
>> device side of the tun interface stops reading frames in order to cause
>> the tun queue to backup and eventually stop. This leads to tx socket
>> buffer backup which provides back pressure to the applications sending
>> traffic over the tun interface.
>> 
>> The determination as to when to stop reading frames or when to throttle
>> back from reading frames is dynamic. It can be based on many things:
>> congestion on the backend media, power level, data rate, etc.
>> 
>> And the application response to back pressure can be as simple as just
>> blocking on a send() or more complex like dynamically throttling data
>> rates or changing compression ratios to reduce overall network load so
>> that when congestion clears there is less of a strain on the network.
>> 
>> Once the tun started dropping packets instead of stopping the queue, it
>> removed the ability for the application controlling the tun to apply its
>> own queue management policy: read frames and possibly discard or stop
>> reading frames. That is the problem, the fixed discard policy.
>> 
>> I'll be posting another version of the patch that allows you to specify
>> the flow control behavior on a queue by queue basis. This would let the
>> application decide what should happen once a queue is full: discard or
>> netif_tx_stop_queue().
>> 
>> I'm not hopeful this solution will be accepted but it might be helpful
>> to someone else.
>> 
>>>> BTW, in my initial noticing this issue, it _seemed_ that even the default interface pfifo_fast priority bands were not being properly enforced for the tap interface without the old flow control behavior?.  I need to do a little more "old vs new" comparison testing on this regard.
>>>> 
>>>> best regards,
>>>> 
>>>> Brian 
>>> 
>>> I think that as tun is never stopped, nothing is ever queued in qdisc.
>>> 
>>> 
>>>> On Apr 10, 2014, at 9:42 PM, Steven Galgano <sgalgano@adjacentlink.com> wrote:
>>>> 
>>>>> On 04/10/2014 06:29 AM, Michael S. Tsirkin wrote:
>>>>>> On Wed, Apr 09, 2014 at 10:19:40PM -0400, Steven Galgano wrote:
>>>>>>> Add tuntap flow control support for use by back pressure routing protocols. Setting the new TUNSETIFF flag IFF_FLOW_CONTROL, will signal resources as unavailable when the tx queue limit is reached by issuing a netif_tx_stop_all_queues() rather than discarding frames. A netif_tx_wake_all_queues() is issued after reading a frame from the queue to signal resource availability.
>>>>>>> 
>>>>>>> Back pressure capability was previously supported by the legacy tun default mode. This change restores that functionality, which was last present in v3.7.
>>>>>>> 
>>>>>>> Reported-by: Brian Adamson <brian.adamson@nrl.navy.mil>
>>>>>>> Tested-by: Joseph Giovatto <jgiovatto@adjacentlink.com>
>>>>>>> Signed-off-by: Steven Galgano <sgalgano@adjacentlink.com>
>>>>>> 
>>>>>> I don't think it's a good idea.
>>>>>> 
>>>>>> This trivial flow control really created more problems than it was worth.
>>>>>> 
>>>>>> In particular this blocks all flows so it's trivially easy for one flow
>>>>>> to block and starve all others: just send a bunch of packets to loopback
>>>>>> destinations that get queued all over the place.
>>>>>> 
>>>>>> Luckily it was never documented so we changed the default and nothing
>>>>>> seems to break, but we won't be so lucky if we add an explicit API.
>>>>>> 
>>>>>> 
>>>>>> One way to implement this would be with ubuf_info callback this is
>>>>>> already invoked in most places where a packet might get stuck for a long
>>>>>> time.  It's still incomplete though: this will prevent head of queue
>>>>>> blocking literally forever, but a single bad flow can still degrade
>>>>>> performance significantly.
>>>>>> 
>>>>>> Another alternative is to try and isolate the flows that we
>>>>>> can handle and throttle them.
>>>>>> 
>>>>>> It's all fixable but we really need to fix the issues *before*
>>>>>> exposing the interface to userspace.
>>>>>> 
>>>>>> 
>>>>>> 
>>>>> 
>>>>> It was only after recent upgrades that we picked up a newer kernel and
>>>>> discovered the change to the default tun mode.
>>>>> 
>>>>> The new default behavior has broken applications that depend on the
>>>>> legacy behavior. Although not documented, the legacy behavior was well
>>>>> known at least to those working in the back pressure research community.
>>>>> The default legacy mode was/is a valid use case although I am not sure
>>>>> it fits with recent multiqueue support.
>>>>> 
>>>>> When back pressure protocols are running over a tun interface they
>>>>> require legacy flow control in order to communicate congestion detected
>>>>> on the physical media they are using. Multiqueues do not apply here.
>>>>> These protocols only use one queue, so netif_tx_stop_all_queues() is the
>>>>> necessary behavior.
>>>>> 
>>>>> I'm not tied to the idea of IFF_FLOW_CONTROL. I was aiming for middle
>>>>> ground where an application controlling the tun interface can state it
>>>>> wants the legacy flow control behavior understanding its limitations
>>>>> concerning multiple queues.
>>>>> 
>>>>> What if we resurrect IFF_ONE_QUEUE and use that as a mechanism to
>>>>> indicate legacy flow control. A tun instance initially configured with
>>>>> IFF_ONE_QUEUE would not be allowed to attach or detach queues with
>>>>> TUNSETQUEUE and any additional opens with the same device name would
>>>>> fail. This mode would use the
>>>>> netif_tx_stop_all_queues()/netif_tx_wake_all_queues() flow control
>>>>> mechanism.
>>>>> 
>>>>> If a tun application wants the current default behavior with only a
>>>>> single queue, it would not set the IFF_ONE_QUEUE flag. Not setting
>>>>> IFF_MULTI_QUEUE would not imply IFF_ONE_QUEUE.
>>>>> 
>>>>> I'd be happy to implement this change if it is an acceptable solution.
>>>>> This would allow multiqueue tun development to advance while still
>>>>> supporting use cases dependent on legacy flow control.
>>>>> 
>>>>> -steve
>>>>> 
>>>>>>> ---
>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>>>> index ee328ba..268130c 100644
>>>>>>> --- a/drivers/net/tun.c
>>>>>>> +++ b/drivers/net/tun.c
>>>>>>> @@ -783,8 +783,19 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>>>>>> 	 * number of queues.
>>>>>>> 	 */
>>>>>>> 	if (skb_queue_len(&tfile->socket.sk->sk_receive_queue) * numqueues
>>>>>>> -			  >= dev->tx_queue_len)
>>>>>>> -		goto drop;
>>>>>>> +			>= dev->tx_queue_len) {
>>>>>>> +		if (tun->flags & TUN_FLOW_CONTROL) {
>>>>>>> +			/* Resources unavailable stop transmissions */
>>>>>>> +			netif_tx_stop_all_queues(dev);
>>>>>>> +
>>>>>>> +			/* We won't see all dropped packets individually, so
>>>>>>> +			 * over run error is more appropriate.
>>>>>>> +			 */
>>>>>>> +			dev->stats.tx_fifo_errors++;
>>>>>>> +		} else {
>>>>>>> +			goto drop;
>>>>>>> +		}
>>>>>>> +	}
>>>>>>> 
>>>>>>> 	if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC)))
>>>>>>> 		goto drop;
>>>>>>> @@ -1362,6 +1373,9 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
>>>>>>> 			continue;
>>>>>>> 		}
>>>>>>> 
>>>>>>> +		/* Wake in case resources previously signaled unavailable */
>>>>>>> +		netif_tx_wake_all_queues(tun->dev);
>>>>>>> +
>>>>>>> 		ret = tun_put_user(tun, tfile, skb, iv, len);
>>>>>>> 		kfree_skb(skb);
>>>>>>> 		break;
>>>>>>> @@ -1550,6 +1564,9 @@ static int tun_flags(struct tun_struct *tun)
>>>>>>> 	if (tun->flags & TUN_PERSIST)
>>>>>>> 		flags |= IFF_PERSIST;
>>>>>>> 
>>>>>>> +	if (tun->flags & TUN_FLOW_CONTROL)
>>>>>>> +		flags |= IFF_FLOW_CONTROL;
>>>>>>> +
>>>>>>> 	return flags;
>>>>>>> }
>>>>>>> 
>>>>>>> @@ -1732,6 +1749,11 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>>>>>>> 	else
>>>>>>> 		tun->flags &= ~TUN_TAP_MQ;
>>>>>>> 
>>>>>>> +	if (ifr->ifr_flags & IFF_FLOW_CONTROL)
>>>>>>> +		tun->flags |= TUN_FLOW_CONTROL;
>>>>>>> +	else
>>>>>>> +		tun->flags &= ~TUN_FLOW_CONTROL;
>>>>>>> +
>>>>>>> 	/* Make sure persistent devices do not get stuck in
>>>>>>> 	 * xoff state.
>>>>>>> 	 */
>>>>>>> @@ -1900,7 +1922,8 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
>>>>>>> 		 * This is needed because we never checked for invalid flags on
>>>>>>> 		 * TUNSETIFF. */
>>>>>>> 		return put_user(IFF_TUN | IFF_TAP | IFF_NO_PI | IFF_ONE_QUEUE |
>>>>>>> -				IFF_VNET_HDR | IFF_MULTI_QUEUE,
>>>>>>> +				IFF_VNET_HDR | IFF_MULTI_QUEUE |
>>>>>>> +				IFF_FLOW_CONTROL,
>>>>>>> 				(unsigned int __user*)argp);
>>>>>>> 	} else if (cmd == TUNSETQUEUE)
>>>>>>> 		return tun_set_queue(file, &ifr);
>>>>>>> diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
>>>>>>> index e9502dd..bcf2790 100644
>>>>>>> --- a/include/uapi/linux/if_tun.h
>>>>>>> +++ b/include/uapi/linux/if_tun.h
>>>>>>> @@ -36,6 +36,7 @@
>>>>>>> #define TUN_PERSIST 	0x0100	
>>>>>>> #define TUN_VNET_HDR 	0x0200
>>>>>>> #define TUN_TAP_MQ      0x0400
>>>>>>> +#define TUN_FLOW_CONTROL 0x0800
>>>>>>> 
>>>>>>> /* Ioctl defines */
>>>>>>> #define TUNSETNOCSUM  _IOW('T', 200, int) 
>>>>>>> @@ -70,6 +71,7 @@
>>>>>>> #define IFF_MULTI_QUEUE 0x0100
>>>>>>> #define IFF_ATTACH_QUEUE 0x0200
>>>>>>> #define IFF_DETACH_QUEUE 0x0400
>>>>>>> +#define IFF_FLOW_CONTROL 0x0010
>>>>>>> /* read-only flag */
>>>>>>> #define IFF_PERSIST	0x0800
>>>>>>> #define IFF_NOFILTER	0x1000

