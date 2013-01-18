Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3ARSgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 13:36:47 -0500
Received: from smtprelay0115.hostedemail.com ([216.40.44.115]:39142 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751554Ab3ARSgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 13:36:45 -0500
X-Panda: scanned!
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,jason@warr.net,:::::::::::,RULES_HIT:355:379:481:599:601:854:945:973:979:981:988:989:1187:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2899:2900:3027:3138:3139:3140:3141:3142:3355:3743:3865:3866:3867:3868:3869:3870:3871:3872:3873:3874:4080:4250:4362:4383:4384:4395:5007:6119:6120:7652:7808:7901:7903:7974:8896:10004:10400:10405:10407:10419:10848:11658:11914:12295:12517:12519:12663:12740:19901:19997,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 6A61736F6E40776172722E6E6574
X-Filterd-Recvd-Size: 4329
Message-ID: <50F9963A.2080608@warr.net>
Date: Fri, 18 Jan 2013 12:36:42 -0600
From: Jason Warr <jason@warr.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Amit Kale <akale@stec-inc.com>
CC: device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD> <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD> <20130116104546.GA3869@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD> <20130117132620.GA2438@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD> <50F844A3.9020300@warr.net> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD> <50F970A3.4000403@warr.net> <20130118161135.GA3118@raspberrypi> <50F97C0F.9010405@warr.net> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/18/2013 11:44 AM, Amit Kale wrote:
>> As much as I dislike Oracle that is one of my primary applications.  I
>> > am attempting to get one of my customers to setup an Oracle instance
>> > that is modular in that I can move the storage around to fit a
>> > particular hardware setup and have a consistent benchmark that they use
>> > in the real world to gauge performance.  One of them is a debit card
>> > transaction clearing entity on multi-TB databases so latency REALLY
>> > matters there.  
> I am curious as to how SSD latency matters so much in the overall transaction times.
>
> We do a lot of performance measurements using SQL database benchmarks. Transaction times vary a lot depending on location of data, complexity of the transaction etc. Typically TPM (transactions per minute) is of primary interest for TPC-C.
>

It's not specifically SSD latency.  It's I/O transaction latency that
matters.  This particular application is very sensitive to that because
it is literally someone standing at a POS terminal swiping a
debit/credit card.  You only have a couple of seconds after the PIN is
entered for the transaction to go through your network, application
server to authorize against a DB and back to the POS.

The entire I/O stack on the DB is only a small time-slice of that round
trip.  Your 99th percentile needs to be under 20ms on the DB storage
side.  If your worst case DB I/O goes beyond 300ms it is considered an
outage because the POS transaction fails.  So it obviously takes allot
of planning and optimization work on the DB itself to get good
tablespace layout to even get into the realm where you can have that
predictable of latency with multi-million dollar FC storage frames. 

One of my goals is to be able to offer this level of I/O service on
commodity hardware.  Simplify the scope of hardware, reduce the number
of points of failure, make the systems more portable, reduce or
eliminate dependence on any specific vendor below the application and
save money.  Not to mention reduce the number of fingers that can point
away from themselves saying it is someone elses problem to find fault.

Allot of the pieces are already out there.  A good block caching target
is one of the missing pieces to help fill the ever growing canyon
between non-block device system performance and storage.  What they have
done with L2ARC and SLOG in ZFS/Solaris is good but it has some serious
short comings in other areas that DM/MD/LVM do extremely well.

I appreciate all of the brilliant work all of you guys do and hopefully
I can contribute a little bit of usefulness to this effort.

Thank you,

Jason
