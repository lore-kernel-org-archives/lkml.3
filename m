Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab3AONUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:20:51 -0500
Received: from myspam1.stec-inc.com ([210.19.18.169]:40483 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755769Ab3AONUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:20:49 -0500
X-ASG-Debug-ID: 1358256039-053ea90dcf1b73d0001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: Mike Snitzer <snitzer@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Date: Tue, 15 Jan 2013 21:19:10 +0800
Subject: RE: Announcement: STEC EnhanceIO SSD caching software for Linux
 kernel
Thread-Topic: Announcement: STEC EnhanceIO SSD caching software for Linux
 kernel
X-ASG-Orig-Subj: RE: Announcement: STEC EnhanceIO SSD caching software for Linux
 kernel
Thread-Index: Ac3yoKI/HYpAmmqfTNq7k/35359UiQAfoF6g
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
In-Reply-To: <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1358256039
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.119925
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> The github code you've referenced is in a strange place; it is
> obviously in a bit of flux.


Git URLs for accessing these are - 

git clone https://github.com/stec-inc/EnhanceIO.git
git clone git://github.com/stec-inc/EnhanceIO.git

> 
> > Repository location -  https://github.com/stec-inc/EnhanceIO

> > ----------------
> > EnhanceIO driver is based on EnhanceIO SSD caching software product
> developed by STEC Inc. EnhanceIO was derived from Facebook's open
> source Flashcache project. EnhanceIO uses SSDs as cache devices for
> traditional rotating hard disk drives (referred to as source volumes
> throughout this document).
> 
> Earlier versions of EnhanceIO made use of Device Mapper (and your
> github code still has artifacts from that historic DM dependency, e.g.
> eio_map still returns DM_MAPIO_SUBMITTED).

This is correct. First version of our product was based on DM.

> 
> As a DM target, EnhanceIO still implemented its own bio splitting
> rather than just use the DM core's bio splitting, now you've decided to
> move away from DM entirely.  Any reason why?

1. EnhanceIO product was always created as a "transparent" cache. This meant the cached device path was identical to the original device path. In order to make this fit into device mapper scheme, we had a bunch of init and udev scripts to replace old device node by a new dm device node. The difficulty in this architecture was the principle reason for moving away from DM. Our transparent cache architecture has been a big winner with enterprise customers enabling easy deployments.

2. EnhanceIO now is fully transparent. So applications can continue running while a cache is created or deleted. This is a significant improvement helping enterprise users reduce downtime.

3. DM overhead is minimal compared to the CPU cycles spent in a cache block lookup. Since we weren't using DM's splitting anyways, that overhead was reduced by going away from DM.

4. We can now create a cache for an entire HDD containing partitions. All the partitions will be cached automatically. User always has an option to cache partitions individually, if required.

5. We have designed our writeback architecture from scratch. Coalescing/bunching together of metadata writes and cleanup is much improved after redesigning of the EnhanceIO-SSD interface. The DM interface would have been too restrictive for this. EnhanceIO uses set level locking, which improves parallelism of IO, particularly for writeback.

> 
> Joe Thornber published the new DM cache target on dm-devel a month ago:
> https://www.redhat.com/archives/dm-devel/2012-December/msg00029.html

Thanks for this link. Will review and get back to you.

> 
> ( I've also kept a functional git repo with that code, and additional
> fixes, in the 'dm-devel-cache' branch of my github repo:
> git://github.com/snitm/linux.git )
> 
> It would be unfortunate if Joe's publishing of the dm-cache codebase
> somehow motivated STEC's switch away from DM (despite EnhanceIO's DM
> roots given it was based on FB's flashcache which also uses DM).

Not at all! We had working on a fully transparent cache architecture since a long time.

> DM really does offer a compelling foundation for stacking storage
> drivers in complementary ways (e.g. we envision dm-cache being stacked
> in conjunction with dm-thinp).  So a DM-based caching layer has been of
> real interest to Red Hat's DM team.

IMHO caching does not DM architecture. DM is best suited for RAID requiring similar or even access to all component devices. Caching requires skewed or uneven access to SSD and HDD.

Regards.
-Amit


> 
> Given dm-cache's clean design and modular cache replacement policy
> interface we were hopeful that any existing limitations in dm-cache
> could be resolved through further work with the greater community (STEC
> included).  Instead, in addition to bcache, with EnhanceIO we have more
> fragmentation for a block caching layer (a layer which has been sorely
> overdue in upstream Linux).
> 
> Hopefully upstream Linux will get this caching feature before its
> utility is no longer needed.  The DM team welcomes review of dm-cache
> from STEC and the greater community.  We're carrying on with dm-cache
> review/fixes for hopeful upstream inclusion as soon as v3.9.
> 
> Mike

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
