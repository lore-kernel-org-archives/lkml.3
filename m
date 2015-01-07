Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbbAGP6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:58:11 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51155 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbbAGP6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:58:06 -0500
Message-ID: <1420646284.5947.19.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: TCP connection issues against Amazon S3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Erik Grinaker <erik@bengler.no>
Cc: Yuchung Cheng <ycheng@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Wed, 07 Jan 2015 07:58:04 -0800
In-Reply-To: <34CE0233-F881-4F40-B119-AA9D8F7D500F@bengler.no>
References: <5DCDADEF-FF9C-4844-8A2C-62E2D3B3B8CE@bengler.no>
	 <1420560253.32621.20.camel@edumazet-glaptop2.roam.corp.google.com>
	 <D5C36777-4461-4B8D-B6C4-38B4276F42DC@bengler.no>
	 <1420564837.32621.30.camel@edumazet-glaptop2.roam.corp.google.com>
	 <8C4F7938-DCA1-46F5-A3C9-7DF62511DEE7@bengler.no>
	 <CAK6E8=d5Z0W5sSAdeEcecKbqjj_UwGw4949=a20fetFpLVKwwA@mail.gmail.com>
	 <03FC652E-AA01-42C7-BD52-019B6D922A9C@bengler.no>
	 <CAK6E8=cP0BFUob5MVj9M0hC0efgRnUY=JMUPKee+v-4TLvHBgg@mail.gmail.com>
	 <76DC89D1-CFCE-44B7-994E-4349FEEDEFA6@bengler.no>
	 <1420575216.5947.12.camel@edumazet-glaptop2.roam.corp.google.com>
	 <4DA8529D-4EEC-42DA-89B0-DC7746DB2B10@bengler.no>
	 <3F608393-E5F1-4647-81BF-C6C740100934@bengler.no>
	 <CAK6E8=cf7cROQ0SON0BihkbOsBB+-sLAbexxgt4_xD+Auqev3Q@mail.gmail.com>
	 <34CE0233-F881-4F40-B119-AA9D8F7D500F@bengler.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-07 at 13:31 +0000, Erik Grinaker wrote:
> On 06 Jan 2015, at 22:00, Yuchung Cheng <ycheng@google.com> wrote:
> > On Tue, Jan 6, 2015 at 1:04 PM, Erik Grinaker <erik@bengler.no> wrote:
> >> 
> >>> On 06 Jan 2015, at 20:26, Erik Grinaker <erik@bengler.no> wrote:
> >> This still doesn’t explain why it works with older kernels, but not newer ones. I’m thinking it’s
> > probably some minor change, which gets amplified by the lack of SACKs
> > on the loadbalancer. Anyway, I’ll bring it up with Amazon.
> > can you post traces with the older kernels?
> 
> Here is a dump using 3.11.10 against a non-SACK-enabled loadbalancer:
> 
> http://abstrakt.bengler.no/tcp-issues-s3-nosack-3.11.10.pcap.bz2
> 
> The transfer shows lots of DUPACKs and retransmits, but this does not
> seem to have as bad an effect as it did with the failing transfer we
> saw on newer kernels:
> 
> http://abstrakt.bengler.no/tcp-issues-s3-failure.pcap.bz2
> 
> One big difference, which Rick touched on earlier, is that the newer
> kernels keep sending TCP window updates as it’s going through the
> retransmits. The older kernel does not do this.

The new kernel is the receiver : It does no retransmits.

Increasing window in ACK packets should not prevent sender into
retransmitting missing packets.

Sender is not a linux host and is very buggy IMO : If receiver
advertises a too big window, sender decides to not retransmit in some
cases.

You can play with /proc/sys/net/ipv4/tcp_rmem and adopt very low values
to work around the sender bug.

( Or use SO_RCVBUF in receiver application)


