Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaDCNTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:19:48 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63864 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaDCNTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:19:38 -0400
Message-ID: <1396531176.12330.6.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: 3.14 regression: huge latency in read/select on tun
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 03 Apr 2014 06:19:36 -0700
In-Reply-To: <533D133A.3090008@odi.ch>
References: <533C381E.9090103@odi.ch>
	 <1396456973.3989.41.camel@edumazet-glaptop2.roam.corp.google.com>
	 <533D133A.3090008@odi.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 09:52 +0200, Ortwin Glück wrote:
> On 02.04.2014 18:42, Eric Dumazet wrote:
> > You could post a tcpdump maybe ?
> 
> This is a dump from on the tun interface (traffic inside the tunnel).
> It's an scp upload of a 2MB file. I aborted after a while when not much
> progress was seen anymore, but you get the idea.
> 
> What I see:
> - Frame 28: long delay because I had to enter the key password
> - Frame 31: the packets seems to be out of order. It has a sequence
> number that is far ahead of previously sent sequence no's. Some
> duplicates and retransmissions follow. That pattern repeats randomly all
> over the trace.
> - from Frame 73 on: ping pong of ACKs and data, while the data is
> delayed by ~200ms caused by the select(). The ping pong also shows that
> there are virtually no packets in flight (see also Window size).

It seems TSO support is broken.

Your trace have no 'big' packets but holes like :

00:41:35.832695 IP 10.243.88.168.35846 > 10.185.85.69.22: Flags [.], ack 6093, win 310, options [nop,nop,TS val 78054 ecr 3191538976], length 0
00:41:35.855990 IP 10.243.88.168.35846 > 10.185.85.69.22: Flags [P.], seq 6696:6776, ack 6093, win 310, options [nop,nop,TS val 78060 ecr 3191538976], length 80
00:41:36.047465 IP 10.185.85.69.22 > 10.243.88.168.35846: Flags [P.], seq 6093:6141, ack 6776, win 218, options [nop,nop,TS val 3191539191 ecr 78060], length 48

missing 6776:14144 sequence (6 segments)

00:41:36.048766 IP 10.243.88.168.35846 > 10.185.85.69.22: Flags [.], seq 14144:15372, ack 6141, win 310, options [nop,nop,TS val 78108 ecr 3191539191], length 1228
00:41:36.057995 IP 10.185.85.69.22 > 10.243.88.168.35846: Flags [.], ack 6776, win 218, options [nop,nop,TS val 3191539202 ecr 78060,nop,nop,sack 1 {14144:15372}], length 0

You are 'saved' because retransmits do not use TSO :

00:41:36.058050 IP 10.243.88.168.35846 > 10.185.85.69.22: Flags [.], seq 6776:8004, ack 6141, win 310, options [nop,nop,TS val 78110 ecr 3191539202], length 1228
00:41:36.058070 IP 10.243.88.168.35846 > 10.185.85.69.22: Flags [.], seq 8004:9232, ack 6141, win 310, options [nop,nop,TS val 78110 ecr 3191539202], length 1228

Also receiver seems to be unable to open TCP window, but thats a secondary problem.



