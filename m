Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbbAHSxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:53:04 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:4689 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbAHSxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:53:02 -0500
Message-ID: <54AED20A.4060806@hp.com>
Date: Thu, 08 Jan 2015 10:52:58 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>, Erik Grinaker <erik@bengler.no>
CC: Yuchung Cheng <ycheng@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: TCP connection issues against Amazon S3
References: <5DCDADEF-FF9C-4844-8A2C-62E2D3B3B8CE@bengler.no> <8C4F7938-DCA1-46F5-A3C9-7DF62511DEE7@bengler.no> <CAK6E8=d5Z0W5sSAdeEcecKbqjj_UwGw4949=a20fetFpLVKwwA@mail.gmail.com> <03FC652E-AA01-42C7-BD52-019B6D922A9C@bengler.no> <CAK6E8=cP0BFUob5MVj9M0hC0efgRnUY=JMUPKee+v-4TLvHBgg@mail.gmail.com> <76DC89D1-CFCE-44B7-994E-4349FEEDEFA6@bengler.no> <1420575216.5947.12.camel@edumazet-glaptop2.roam.corp.google.com> <4DA8529D-4EEC-42DA-89B0-DC7746DB2B10@bengler.no> <3F608393-E5F1-4647-81BF-C6C740100934@bengler.no> <CAK6E8=cf7cROQ0SON0BihkbOsBB+-sLAbexxgt4_xD+Auqev3Q@mail.gmail.com> <34CE0233-F881-4F40-B119-AA9D8F7D500F@bengler.no> <1420646284.5947.19.camel@edumazet-glaptop2.roam.corp.google.com> <A58F8257-97F8-4662-98FC-7AC57F35A3A4@bengler.no> <1420666401.5947.35.camel@edumazet-glaptop2.roam.corp.google.com> <DCC8B9AB-D1D7-4722-9B65-93AB5A559763@bengler.no> <1420740936.5947.70.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1420740936.5947.70.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Strange thing is that sender does not misbehave at the beginning when
> receiver window is still small. Only after a while.

Just guessing, but when the receiver window is small, the sender cannot 
get a large quantity of data out there at once, so any string of lost 
packets will tend to be smaller.  If the sender is relying on the RTO to 
trigger the retransmits, and is not resetting his RTO until the clean 
ACK of a segment sent after snd_nxt when the loss is detected, the 
smaller loss strings will not get to the rather large RTO values seen in 
the trace before curl gives-up.  It may be that the sender is indeed 
misbehaving at the beginning, just that it isn't noticeable?

Different but perhaps related observation/question - without timestamps 
(which we don't have in this case), isn't there a certain ambiguity 
about arriving out-of-order segments? One doesn't really know if they 
are out-of-order because the network is re-ordering, or because they are 
retransmissions of segments we've not yet seen at the receiver.

rick
