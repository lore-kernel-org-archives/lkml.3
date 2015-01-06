Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbbAFTvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:51:11 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33271 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756436AbbAFTun convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:50:43 -0500
X-Sasl-enc: Z0f6JfeoXHkg4n0N/KwjRTT3RGdAFdJ6bdmjF72lcPmO 1420573843
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: TCP connection issues against Amazon S3
From: Erik Grinaker <erik@bengler.no>
In-Reply-To: <54AC348B.4030900@hp.com>
Date: Tue, 6 Jan 2015 19:50:41 +0000
Cc: Yuchung Cheng <ycheng@google.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <FB6A6CF4-0E3F-4BA7-90B1-5DC5FDE12DDE@bengler.no>
References: <5DCDADEF-FF9C-4844-8A2C-62E2D3B3B8CE@bengler.no> <1420560253.32621.20.camel@edumazet-glaptop2.roam.corp.google.com> <D5C36777-4461-4B8D-B6C4-38B4276F42DC@bengler.no> <1420564837.32621.30.camel@edumazet-glaptop2.roam.corp.google.com> <8C4F7938-DCA1-46F5-A3C9-7DF62511DEE7@bengler.no> <CAK6E8=d5Z0W5sSAdeEcecKbqjj_UwGw4949=a20fetFpLVKwwA@mail.gmail.com> <54AC348B.4030900@hp.com>
To: Rick Jones <rick.jones2@hp.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06 Jan 2015, at 19:16, Rick Jones <rick.jones2@hp.com> wrote:
> 
>>>>>>> A packet dump [1] shows repeated ACK retransmits for some of the
>> TCP does not retransmit ACK ... do you mean DUPACKs sent by the receiver?
>> 
>> I am trying to understand the problem. Could you confirm that it's the
>> HTTP responses sent from Amazon S3 got stalled, or HTTP requests sent
>> from the receiver (your host)?
>> 
>> btw I suspect some middleboxes are stripping SACKOK options from your
>> SYNs (or Amazon SYN-ACKs) assuming Amazon supports SACK.
> 
> The TCP Timestamp option too it seems.
> 
> Speaking of middleboxes...  It is probably a fish that is red, but a while back I stepped in a middle box (a load balancer) which decided that if it saw "too many" retransmissions in a given TCP window that something was seriously wrong and it would toast the connection.  I thought though that was an active reset on the part of the middlebox. (And the client was the active sender not the back-end server)

It’s looking increasingly probable that it’s something like that, since the sender (S3) appears to disable SACKs on the failing clients, while it enables SACKs on other functioning clients.

> I'm assuming one incident starts at XX:41:24.748265 in the trace?  That does look like it is slowly slogging its way through a bunch of lost traffic, which was I think part of the problem I was seeing with the middlebox I stepped in, but I don't think I see the reset where I would have expected it.  Still, it looks like the sender has an increasing TCP RTO as it is going through the slog (as it likely must since there are no TCP timestamps?), to the point it gets larger than I'm guessing curl was willing to wait, so the FIN at XX:41:53.269534 after a ten second or so gap.

Yes, there is one incident starting at XX:41:23. All the RSTs are sent at the end though, at the 30s Curl timeout. I’ve put up a stripped down pcap of a single request here:

http://abstrakt.bengler.no/tcp-issues-s3-failure.pcap.bz2


