Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbbA0ReV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:34:21 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51343 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbbA0ReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:34:18 -0500
Message-ID: <54C7CC18.1070307@gmail.com>
Date: Tue, 27 Jan 2015 09:34:16 -0800
From: Alexander Duyck <alexander.duyck@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Choi, Sy Jong" <sy.jong.choi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Hayato Momma <h-momma@ce.jp.nec.com>
Subject: Re: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast promiscuous
 mode control
References: <7F861DC0615E0C47A872E6F3C5FCDDBD05E0734E@BPXM14GP.gisp.nec.co.jp>	<7F861DC0615E0C47A872E6F3C5FCDDBD05E07F09@BPXM14GP.gisp.nec.co.jp>	<F6FB0E698C9B3143BDF729DF222866469129B844@ORSMSX110.amr.corp.intel.com>	<7F861DC0615E0C47A872E6F3C5FCDDBD05E08FF6@BPXM14GP.gisp.nec.co.jp>	<063D6719AE5E284EB5DD2968C1650D6D1CAD01D6@AcuExch.aculab.com>	<7F861DC0615E0C47A872E6F3C5FCDDBD05E090FE@BPXM14GP.gisp.nec.co.jp>	<F6FB0E698C9B3143BDF729DF222866469129BC03@ORSMSX110.amr.corp.intel.com>	<063D6719AE5E284EB5DD2968C1650D6D1CAD0C8A@AcuExch.aculab.com>	<F6FB0E698C9B3143BDF729DF222866469129BFFD@ORSMSX110.amr.corp.intel.com>	<87bnlqpq6v.fsf@nemi.mork.no>	<F6FB0E698C9B3143BDF729DF222866469129C09C@ORSMSX110.amr.corp.intel.com> <7F861DC0615E0C47A872E6F3C5FCDDBD05E0B6B1@BPXM14GP.gisp.nec.co.jp> <54C1F5BF.30105@gmail.com> <F6FB0E698C9B3143BDF729DF222866469129C3D0@ORSMSX110.amr.corp.intel.com> <7F861DC0615E0C47A872E6F3C5FCDDBD05E1335D@BPXM14GP.gisp.nec.co.jp>
In-Reply-To: <7F861DC0615E0C47A872E6F3C5FCDDBD05E1335D@BPXM14GP.gisp.nec.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 04:53 AM, Hiroshi Shimamoto wrote:
>>> On 01/22/2015 04:32 PM, Hiroshi Shimamoto wrote:
>>>>> Subject: RE: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast
>>>>> promiscuous mode control
>>>>>> "Skidmore, Donald C" <donald.c.skidmore@intel.com> writes:
>>>>>>
>>>>>>> My hang up is more related to: without the nob to enable it (off by
>>>>>>> default) we are letting one VF dictate policy for all the other VFs
>>>>>>> and the PF.  If one VF needs to be in promiscuous multicast so is
>>>>>>> everyone else.  Their stacks now needs to deal with all the extra
>>>>>>> multicast packets.  As you point out this might not be a direct
>>>>>>> concern for isolation in that the VM could have 'chosen' to join
>>>>>>> any Multicast group and seen this traffic.  My concern over
>>>>>>> isolation is one VF has chosen that all the other VM now have to
>>>>>>> see this multicast traffic.
>>>>>> Apologies if this question is stupid, but I just have to ask about
>>>>>> stuff I don't understand...
>>>>>>
>>>>>> Looking at the proposed implementation, the promiscous multicast
>>>>>> flag seems to be a per-VF flag:
>>>>>>
>>>>>> +int ixgbe_ndo_set_vf_mc_promisc(struct net_device *netdev, int vf,
>>>>>> +bool
>>>>>> +setting) {
>>>>>> +	struct ixgbe_adapter *adapter = netdev_priv(netdev);
>>>>>> +	struct ixgbe_hw *hw = &adapter->hw;
>>>>>> +	u32 vmolr;
>>>>>> +
>>>>>> +	if (vf >= adapter->num_vfs)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	adapter->vfinfo[vf].mc_promisc_enabled = setting;
>>>>>> +
>>>>>> +	vmolr = IXGBE_READ_REG(hw, IXGBE_VMOLR(vf));
>>>>>> +	if (setting) {
>>>>>> +		e_info(drv, "VF %u: enabling multicast promiscuous\n", vf);
>>>>>> +		vmolr |= IXGBE_VMOLR_MPE;
>>>>>> +	} else {
>>>>>> +		e_info(drv, "VF %u: disabling multicast promiscuous\n", vf);
>>>>>> +		vmolr &= ~IXGBE_VMOLR_MPE;
>>>>>> +	}
>>>>>> +
>>>>>> +	IXGBE_WRITE_REG(hw, IXGBE_VMOLR(vf), vmolr);
>>>>>> +
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +
>>>>>>
>>>>>> I haven't read the data sheet, but I took a quick look at the
>>>>>> excellent high level driver docs:
>>>>>> http://www.intel.com/content/dam/doc/design-guide/82599-sr-iov-
>>> drive
>>>>>> r-
>>>>>> companion-guide.pdf
>>>>>>
>>>>>> It mentions "Multicast Promiscuous Enable" in its "Thoughts for
>>>>>> Customization" section:
>>>>>>
>>>>>>  7.1 Multicast Promiscuous Enable
>>>>>>
>>>>>>  The controller has provisions to allow each VF to be put into
>>>>>> Multicast Promiscuous mode.  The Intel reference driver does not
>>>>>> configure this option .
>>>>>>
>>>>>>  The capability can be enabled/disabled by manipulating the MPE
>>>>>> field  (bit
>>>>>> 28) of the PF VF L2 Control Register (PFVML2FLT – 0x0F000)
>>>>>>
>>>>>> and showing a section from the data sheet describing the "PF VM L2
>>>>>> Control Register - PFVML2FLT[n]  (0x0F000 + 4 * n, n=0...63; RW)"
>>>>>>
>>>>>> To me it looks like enabling Promiscuos Multicast for a VF won't
>>>>>> affect any other VF at all.  Is this really not the case?
>>>>>>
>>>>>>
>>>>>>
>>>>>> Bjørn
>>>>> Clearly not a dumb question at all and I'm glad you mentioned that.
>>>>> :)  I was going off the assumption, been awhile since I read the
>>>>> patch, that the patch was using FCTRL.MPE or MANC.MCST_PASS_L2
>>> which would turn multicast promiscuous on for everyone.  Since the patch is
>>> using PFVML2FLT.MPE this lessens my concern over effect on the entire
>>> system.
>>>> I believe the patches for this VF multicast promiscuous mode is per VF.
>>>>
>>>>> That said I still would prefer having a way to override this behavior on the
>>> PF, although I admit my argument is weaker.
>>>>> I'm still concerned about a VF changing the behavior of the PF
>>>>> without any way to prevent it.  This might be one part philosophical
>>>>> (PF sets policy not the VF) but this still could have a noticeable
>>>>> effect on the overall system.  If any other VFs (or the PF) are
>>>>> receiving MC packets these will have to be replicated which will be a
>>>>> performance hit.  When we use the MC hash this is limited vs. when
>>> anyone is in MC promiscuous every MC packet used by another pool would
>>> be replicated.  I could imagine in some environments (i.e. public clouds)
>>> where you don't trust what is running in your VM you might what to block
>>> this from happening.
>>>> I understand your request and I'm thinking to submit the patches
>>>>   1) Add new mbox API between ixgbe/ixgbevf to turn MC promiscuous on,
>>>>      and enables it when ixgbevf needs over 30 MC addresses.
>>>>   2) Add a policy knob to prevent enabling it from the PF.
>>>>
>>>> Does it seem okay?
>>> I would advise that if such a knob is added it should be set to disabled by
>>> default.  The main problem with supporting that many multicast addresses
>>> per VF is that you run the risk for flooding the PCIe interface on the network
>>> adapter if too many adapters were to go into such a mode.
>>>
>> This was my understanding as well.  Someone would have to "choose" to allow VM to enter this mode, meaning off by default.
> I see you'd like to keep it off unless the administrator wants to configure.

Correct.  This is a somewhat risky configuration so it is best to
control who has access to it.

One additional thought is that you may want to make it so that the VF
has some control over it from its side as well.  In the case of the igb
driver I believe there is already a control for setting the multicast
promiscuous in the event of exceeding 30 multicast addresses.  You may
want to look at that for ideas on how to have a mailbox message work in
conjunction with your control to allow enabling/disabling the multicast
promiscuous mode.

>>>> BTW, I'm bit worried about to use ndo interface for 2) because adding
>>>> a new hook makes core code complicated.
>>>> Is it really reasonable to do it with ndo?
>>>> I haven't find any other suitable method to do it, right now. And
>>>> using ndo VF hook looks standard way to control VF functionality.
>>>> Then, I think it's the best way to implement this policy in ndo hook.
>>> The ndo is probably the only way to go on this.  It is how past controls for the
>>> VF network functionality have been implemented.
>>>
>>>>> In some ways it is almost the mirror image of the issue you brought up:
>>>>>
>>>>> Adding a new hook for this seems over-complicated to me.  And it
>>>>> still doesn't solve the real problems that
>>>>>  a) the user has to know about this limit, and
>>>>>  b) manually configure the feature
>>>>>
>>>>> My reverse argument might be that if this happens automatically.  It
>>>>> might take the VM provider a long time to realize performance has
>>>>> taken a hit because some VM asked to join 31 multicast groups and
>>> entered MC promiscuous.  Then only to find that they have no way to block
>>> such behavior.
>>>>> Maybe I wouldn't as concerned if the patch author could provide some
>>>>> performance results to show this won't have as a negative effect as I'm
>>> afraid it might?
>>>> Hm, what kind of test case would you like to have?
>>>> The user A who has 30 MC addresses vs the user B who has 31 MC
>>>> addresses, which means that MC promiscuous mode, and coming MC
>>> packets the user doesn't expect?
>>>> thanks,
>>>> Hiroshi
>>> The question I would have is how many of these interfaces do you expect to
>>> have supporting the expanded multicast mode?  As it currently stands
> Right now, we're thinking 1 or 2 VFs per PF will be enabled this feature
> in our use case. Another representation, 1 or 2 VMs will be used VF device on
> one server, each VM has 2 VFs usually.

This seems reasonable.  If it is only one or two VFs then you probably
would be better of using the promiscuous mode.

>>> multicast traffic has the potential to flood the adapter, greatly reduce the
>>> overall throughput, and add extra workload to the PF and all VFs.
>>> For example if several VFs enable this feature, and then someone on the
>>> network sends a stream of multicast traffic what happens to the CPU load for
>>> the host system?
> I'm not sure why all VFs are affected.
> I can imagine that PF and VFs which are enabled this feature could receive
> flooding packets, but other VFs never receive such packets.

The other VFs would't be receiving the traffic, they would just have
reduced access to traffic because for each VF that can receive a packet
it multiplies the PCIe bandwidth.  So if you have 4 VFs in multicast
promiscuous mode then that means for each multicast frame receive the
PCIe bus will have to pass the frame 4 times in order to provide a copy
to each VF.   When you consider that the 82599 can support 64 VFs this
replication can have a huge impact on the PCIe bus bandwidth.

>>> Also how many addresses beyond 30 is it you require?  An alternative to
>>> adding multicast promiscuous might be to consider extending the mailbox
>>> API to support sending more than 30 addresses via something such as a
>>> multi-part multicast configuration message.  The fm10k driver already has
>>> logic similar to this as it adds addresses 1 at a time though a separate Switch
>>> interface API between the PF and the Switch.  You might be able to reuse
>>> some of that code to reach beyond the 30 address limit.
>> I think this would be a much safer approach and probably scale well for small sets.  However I don't think it would work
>> for Hiroshi's use case.  If I remember correctly he wanted 1000's of MC groups per VM.   I imagine there would be considerable
>> overhead even loading up our 4K hash table 1 address at a time, likewise with that many address wouldn't this just be
>> pretty much the same as being in multicast promiscuous.  Still this might be an interesting approach to support those
>> needing only a few MC groups over the limit.
> We would like to use 2000 IPs usually, and would extend to 4k which comes from VLAN limit.
> IIRC, mbox API has only 32 words, it doesn't scale, I think.
> And there is a single hash table per PF, not per VF. I guess if we set 4k hash entries
> from a specific VF, every VF will receive all MC packets.

This is true.  So if you only have one or two VFs that you expect to
need that many entries it might be preferable to go the multicast
promiscuous route to avoid excess replication.

>> Alex's point is worth reiterating, this will effect performance.  Have you tested this out under load and still see the
>> results you can live with?
> I don't have any number in MC load.
> In general case, we have enough performance in VM, almost wire rate in our scenario.
>
> thanks,
> Hiroshi
>

I'd say your best bet for this is to make it both an NDO (defaulted to
disabled) and a mailbox request.  If both are enabling it then enable
the feature.  That way you can avoid possibly sending unexpected packets
to a legacy VF, or allowing a VF to enable it on a system that hasn't
been configured for it.

- Alex
