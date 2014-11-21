Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaKUBsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:48:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34360 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757760AbaKUBr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:47:59 -0500
Date: Thu, 20 Nov 2014 17:47:27 -0800
From: Calvin Owens <calvinowens@fb.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>, Eric Dumazet <edumazet@google.com>,
        <kernel-team@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tcp: Restore RFC5961-compliant behavior for SYN packets
Message-ID: <20141121014727.GA1536781@mail.thefacebook.com>
References: <1416524993-26228-1-git-send-email-calvinowens@fb.com>
 <1416526940.8629.62.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1416526940.8629.62.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-21_01:2014-11-20,2014-11-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.140620555742602 urlsuspect_oldscore=0.140620555742602
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.140620555742602 spamscore=0
 recipient_to_sender_domain_totalscore=1 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411210012
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11/20 at 15:42 -0800, Eric Dumazet wrote:
> On Thu, 2014-11-20 at 15:09 -0800, Calvin Owens wrote:
> > Commit c3ae62af8e755 ("tcp: should drop incoming frames without ACK
> > flag set") was created to mitigate a security vulnerability in which a
> > local attacker is able to inject data into locally-opened sockets by
> > using TCP protocol statistics in procfs to quickly find the correct
> > sequence number.
> > 
> > This broke the RFC5961 requirement to send a challenge ACK in response
> > to spurious RST packets, which was subsequently fixed by commit
> > 7b514a886ba50 ("tcp: accept RST without ACK flag").
> > 
> > Unfortunately, the RFC5961 requirement that spurious SYN packets be
> > handled in a similar manner remains broken.
> > 
> > RFC5961 section 4 states that:
> > 
> >    ... the handling of the SYN in the synchronized state SHOULD be
> >    performed as follows:
> > 
> >    1) If the SYN bit is set, irrespective of the sequence number, TCP
> >       MUST send an ACK (also referred to as challenge ACK) to the remote
> >       peer:
> > 
> >       <SEQ=SND.NXT><ACK=RCV.NXT><CTL=ACK>
> > 
> >       After sending the acknowledgment, TCP MUST drop the unacceptable
> >       segment and stop processing further.
> > 
> >    By sending an ACK, the remote peer is challenged to confirm the loss
> >    of the previous connection and the request to start a new connection.
> >    A legitimate peer, after restart, would not have a TCB in the
> >    synchronized state.  Thus, when the ACK arrives, the peer should send
> >    a RST segment back with the sequence number derived from the ACK
> >    field that caused the RST.
> > 
> >    This RST will confirm that the remote peer has indeed closed the
> >    previous connection.  Upon receipt of a valid RST, the local TCP
> >    endpoint MUST terminate its connection.  The local TCP endpoint
> >    should then rely on SYN retransmission from the remote end to
> >    re-establish the connection.
> > 
> > This patch lets SYN packets through the discard added in c3ae62af8e755,
> > so that spurious SYN packets are properly dealt with as per the RFC.
> > 
> > The challenge ACK is sent unconditionally and is rate-limited, so the
> > original vulnerability is not reintroduced by this patch.
> 
> 
> I think this patch makes sense. But I wonder if the rate limiting wont
> hurt anyway, as I presume you need that after some server being
> rebooted, and if many connections are attempted in a small amount of
> time, some of them wont get any answer ?

That's actually not what led to finding this, but it's a good point. :)

What if the challenge-ACK counter were decremented in tcp_validate_incoming()
when a valid RST packet is seen? That would allow legitimate remote
hosts to reestablish connections without being ratelimited, and still
prevent a malicious host from guessing sequence numbers.

There would need to be a way to tell if a challenge ACK had in fact been
sent and only decrement in that case, since otherwise a local attacker
could establish and immediately reset lots of connections to keep the
counter below the ratelimit threshold and guess sequence numbers.

Simply adding a flag to struct tcp_sock would work: just set the flag
whenever a challenge ACK is sent, and clear it and decrement the counter
only if it is set when a valid RST packet is seen.

I suppose that should be a seperate patch?

Thanks,
Calvin 
