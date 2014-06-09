Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbaFIJVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:21:22 -0400
Received: from smtp.pobox.com ([208.72.237.35]:63806 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbaFIJVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:subject:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=tCCdaLmHhRRjWm9y6Ke
	LQHos+nBJCCgtSjOI1BDZ5qMgiKX/EJIvmjgsoO0IB9EtrxIO7ScWVO6OrnNOTZm
	Gup0Gn14JCGsxn9VuiRXqh/aGAoctc2PP0ZtfdytGo5+GKG/gBzPMT2G7/Vcl+yA
	/M4TwIEFy0h+3jV3VOUUEi8U=
Message-ID: <53957C85.4040700@pobox.com>
Date: Mon, 09 Jun 2014 10:21:09 +0100
From: Brian Candler <b.candler@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: tap interface apparently rate-limited to 1 packet per 12ms
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 64F44566-EFB7-11E3-B5CC-9903E9FBB39C-28021239!pb-smtp0.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Aside: I posted this to netdev, no reply. I apologise if you have seen 
this before]

I have a performance problem which I've narrowed down to some bizarre 
behaviour of tap interfaces, and I've made an easily reproducible test 
case.

It seems that no matter how fast you queue packets for a tap interface, 
they are only being forwarded at one packet every 10 to 12 ms, limiting 
you to around 80-100 packets per second. This is as shown by tcpdump on 
the tap interface - not even on the userland process listening on the tap.

This also happens with tun interfaces, which I'd have thought would 
affect a lot of VPN software, so quite possibly there's something under 
the surface which I don't understand.

To reproduce, open three root windows.

(1)

gcc -Wall -o use_tap use_tap.c     # see source code below
./use_tap # just creates tap interface and keeps it open

(2)

tcpdump -i tap99 -nn

(3)

ifconfig tap99 1.1.1.2/30 up
arp -i tap99 -s 1.1.1.1 11:11:11:11:11:11
ping -fq -c20 1.1.1.1

You will see on the tcpdump screen something like this:

# tcpdump -i tap99 -nn
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on tap99, link-type EN10MB (Ethernet), capture size 65535 bytes
12:17:36.157450 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 1, 
length 64
12:17:36.169374 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 2, 
length 64
12:17:36.181378 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 3, 
length 64
12:17:36.193373 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 4, 
length 64
12:17:36.205373 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 5, 
length 64
12:17:36.217381 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 6, 
length 64
12:17:36.229373 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 7, 
length 64
12:17:36.241372 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 8, 
length 64
12:17:36.253373 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 9, 
length 64
12:17:36.265373 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 
10, length 64
12:17:36.277373 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 
11, length 64
12:17:36.289372 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 
12, length 64
12:17:36.301373 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 
13, length 64
12:17:36.313373 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 
14, length 64
12:17:36.325372 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 
15, length 64
12:17:36.337372 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 
16, length 64
12:17:36.349373 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 
17, length 64
12:17:36.361373 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 
18, length 64
12:17:36.373374 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 
19, length 64
12:17:36.385373 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 6417, seq 
20, length 64

Look at the timetamps of the packets. They are 0.012 seconds apart exactly.

The above captures were made on an Intel DN2820 NUC running Debian 
Wheezy with kernel 3.2.0-4-amd64

I can find no evidence of configured rate limiting:

# tc qdisc show dev tap99
qdisc pfifo_fast 0: root refcnt 2 bands 3 priomap  1 2 2 2 1 2 0 0 1 1 1 
1 1 1 1 1

Now: I'm only using ping -fq as a simple way to generate packets. You 
can easily demonstrate to yourself that this is not the source of the 
delay (e.g. by sending the same ping -fq command to a random device on 
your network, and looking at the timestamps of the outgoing pings; 
expect to see 10 or more pings within the same millisecond).

The real-world problem I am trying to fix is TCP throughput with 
dynamips. Here's the setup:

<KVM vnet0> ---- <br1> --- <tap1 DYNAMIPS1 tap11> --- <br-lan> --- host
<KVM vnet1> ---'

Here the platform is a Mac Mini i7 running Ubuntu 12.04.4 with kernel 
3.8.0-41, and dynamips 0.2.12.

When using wget on a KVM instance to fetch a large file form the host, 
the total TCP throughput I was observing through the dynamips router was 
around 130KB/s. Furthermore, if I ran a wget on the second KVM at the 
same time, then the total bandwidth was divided between them. But if I 
started another download from another KVM via another dynamips instance 
(br2/tap2/tap12) then it got its own independent 130KB/s without 
affecting the ones behind br1. CPU usage of dynamips was moderate (about 
half a core of this four-core box).

Transfers between two KVM instances both locally attached to br1 are 
very fast.

By comparing tcpdump on br-lan with tcpdump on tap11 (both taken at the 
same time on the same host), I could see that the host was sending a 
window-full of TCP segments in quick succession, but they were being 
drip-fed out of tap11.

Here's what I saw on br-lan:

# tcpdump -r br-lan.pcap -nn | head -20
reading from file br-lan.pcap, link-type EN10MB (Ethernet)
10:24:01.446755 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [S], seq 
1242930289, win 14600, options [mss 1460,sackOK,TS val 1325806 ecr 
0,nop,wscale 3], length 0
10:24:01.446805 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [S.], seq 
976209917, ack 1242930290, win 14480, options [mss 1460,sackOK,TS val 
2606216 ecr 1325806,nop,wscale 7], length 0
10:24:01.466969 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 1, 
win 1825, options [nop,nop,TS val 1325819 ecr 2606216], length 0
10:24:01.497357 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [P.], seq 
1:150, ack 1, win 1825, options [nop,nop,TS val 1325819 ecr 2606216], 
length 149
10:24:01.497395 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], ack 150, 
win 122, options [nop,nop,TS val 2606229 ecr 1325819], length 0
10:24:01.497705 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
1:1449, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 1325819], 
length 1448
10:24:01.497720 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
1449:2897, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 
1325819], length 1448
10:24:01.497726 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
2897:4345, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 
1325819], length 1448
10:24:01.497732 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
4345:5793, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 
1325819], length 1448
10:24:01.497737 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
5793:7241, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 
1325819], length 1448
10:24:01.497743 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
7241:8689, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 
1325819], length 1448
10:24:01.527775 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 
1449, win 2187, options [nop,nop,TS val 1325834 ecr 2606229], length 0
10:24:01.527827 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
8689:10137, ack 150, win 122, options [nop,nop,TS val 2606236 ecr 
1325834], length 1448
10:24:01.527839 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
10137:11585, ack 150, win 122, options [nop,nop,TS val 2606236 ecr 
1325834], length 1448
10:24:01.527847 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [P.], seq 
11585:12596, ack 150, win 122, options [nop,nop,TS val 2606236 ecr 
1325834], length 1011
10:24:01.527856 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
12596:14044, ack 150, win 122, options [nop,nop,TS val 2606236 ecr 
1325834], length 1448
10:24:01.527862 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
14044:15492, ack 150, win 122, options [nop,nop,TS val 2606236 ecr 
1325834], length 1448
10:24:01.629571 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 
2897, win 2549, options [nop,nop,TS val 1325837 ecr 2606229], length 0
10:24:01.629593 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [P.], seq 
15492:16940, ack 150, win 122, options [nop,nop,TS val 2606262 ecr 
1325837], length 1448
10:24:01.639742 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 
4345, win 2911, options [nop,nop,TS val 1325839 ecr 2606229], length 0

(notice burst of packets with timestamp 10:24:01.497xxx). 10.10.1.1 is 
the KVM VM, and 10.10.0.241 is the host's own address on br-lan.

And on tap1:

root@kit1:~# tcpdump -r tap1.pcap -nn | head -20
reading from file tap1.pcap, link-type EN10MB (Ethernet)
10:24:01.406738 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [S], seq 
1242930289, win 14600, options [mss 1460,sackOK,TS val 1325806 ecr 
0,nop,wscale 3], length 0
10:24:01.456885 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [S.], seq 
976209917, ack 1242930290, win 14480, options [mss 1460,sackOK,TS val 
2606216 ecr 1325806,nop,wscale 7], length 0
10:24:01.457031 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 1, 
win 1825, options [nop,nop,TS val 1325819 ecr 2606216], length 0
10:24:01.457155 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [P.], seq 
1:150, ack 1, win 1825, options [nop,nop,TS val 1325819 ecr 2606216], 
length 149
10:24:01.507498 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], ack 150, 
win 122, options [nop,nop,TS val 2606229 ecr 1325819], length 0
10:24:01.517653 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
1:1449, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 1325819], 
length 1448
10:24:01.517794 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 
1449, win 2187, options [nop,nop,TS val 1325834 ecr 2606229], length 0
10:24:01.527756 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
1449:2897, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 
1325819], length 1448
10:24:01.527866 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 
2897, win 2549, options [nop,nop,TS val 1325837 ecr 2606229], length 0
10:24:01.537982 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
2897:4345, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 
1325819], length 1448
10:24:01.538089 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 
4345, win 2911, options [nop,nop,TS val 1325839 ecr 2606229], length 0
10:24:01.548166 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
4345:5793, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 
1325819], length 1448
10:24:01.548363 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 
5793, win 3273, options [nop,nop,TS val 1325842 ecr 2606229], length 0
10:24:01.558361 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
5793:7241, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 
1325819], length 1448
10:24:01.558455 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 
7241, win 3635, options [nop,nop,TS val 1325844 ecr 2606229], length 0
10:24:01.568493 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
7241:8689, ack 150, win 122, options [nop,nop,TS val 2606229 ecr 
1325819], length 1448
10:24:01.568654 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 
8689, win 3997, options [nop,nop,TS val 1325847 ecr 2606229], length 0
10:24:01.588911 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
8689:10137, ack 150, win 122, options [nop,nop,TS val 2606236 ecr 
1325834], length 1448
10:24:01.589087 IP 10.10.1.1.38590 > 10.10.0.241.80: Flags [.], ack 
10137, win 4359, options [nop,nop,TS val 1325852 ecr 2606236], length 0
10:24:01.599135 IP 10.10.0.241.80 > 10.10.1.1.38590: Flags [.], seq 
10137:11585, ack 150, win 122, options [nop,nop,TS val 2606236 ecr 
1325834], length 1448

These appear to be at intervals of about 10.2 ms, or 98 packets per 
second. tcpdump on the KVM VM also saw the packets arrive at these 
intervals.

So with a segment size of 1448 bytes, and limited to 98 packets per 
second, this gives a theoretical throughput of 142KB/sec, close to what 
I measured.

I have one more machine I've tried this on: an older AMD Athlon X2 but 
running Ubuntu 14.04 with kernel 3.13.0-27-generic. Using the 
reproducing test case given at the start of this mail, I see:

# tcpdump -i tap99 -nn
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on tap99, link-type EN10MB (Ethernet), capture size 65535 bytes
13:28:00.381053 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 1, 
length 64
13:28:00.402796 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 2, 
length 64
13:28:00.414789 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 3, 
length 64
13:28:00.426785 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 4, 
length 64
13:28:00.438777 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 5, 
length 64
13:28:00.450781 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 6, 
length 64
13:28:00.462781 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 7, 
length 64
13:28:00.474783 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 8, 
length 64
13:28:00.486768 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 9, 
length 64
13:28:00.498768 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 
10, length 64
13:28:00.510766 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 
11, length 64
13:28:00.522767 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 
12, length 64
13:28:00.534767 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 
13, length 64
13:28:00.546766 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 
14, length 64
13:28:00.558766 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 
15, length 64
13:28:00.570766 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 
16, length 64
13:28:00.582767 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 
17, length 64
13:28:00.594767 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 
18, length 64
13:28:00.606768 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 
19, length 64
13:28:00.618766 IP 1.1.1.2 > 1.1.1.1: ICMP echo request, id 5141, seq 
20, length 64

These all appear to be at intervals of 12ms too.

I'm stumped as to what could be the cause of this - does anyone have any 
suggestions?

Thanks,

Brian.

----- 8< -----
/* http://backreference.org/2010/03/26/tuntap-interface-tutorial/ */

#include <net/if.h>
#include <linux/if_tun.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

#include <stdio.h>
#include <unistd.h>

int tun_alloc(char *dev, int flags) {

   struct ifreq ifr;
   int fd, err;
   char *clonedev = "/dev/net/tun";

   /* Arguments taken by the function:
    *
    * char *dev: the name of an interface (or '\0'). MUST have enough
    *   space to hold the interface name if '\0' is passed
    * int flags: interface flags (eg, IFF_TUN etc.)
    */

    /* open the clone device */
    if( (fd = open(clonedev, O_RDWR)) < 0 ) {
      return fd;
    }

    /* preparation of the struct ifr, of type "struct ifreq" */
    memset(&ifr, 0, sizeof(ifr));

    ifr.ifr_flags = flags;   /* IFF_TUN or IFF_TAP, plus maybe IFF_NO_PI */

    if (*dev) {
      /* if a device name was specified, put it in the structure; otherwise,
       * the kernel will try to allocate the "next" device of the
       * specified type */
      strncpy(ifr.ifr_name, dev, IFNAMSIZ);
    }

    /* try to create the device */
    if( (err = ioctl(fd, TUNSETIFF, (void *) &ifr)) < 0 ) {
      close(fd);
      return err;
    }

   /* if the operation was successful, write back the name of the
    * interface to the variable "dev", so the caller can know
    * it. Note that the caller MUST reserve space in *dev (see calling
    * code below) */
   strcpy(dev, ifr.ifr_name);

   /* this is the special file descriptor that the caller will use to talk
    * with the virtual interface */
   return fd;
}

int main(void) {
   char buf[] = "tap99";
   int fd = tun_alloc(buf, IFF_TAP);
   if (fd < 0) { perror("tun_alloc"); return 1; }
   fprintf(stderr,"%s open\n", buf);
   while(1) { sleep(3600); }
   return 0;
}

