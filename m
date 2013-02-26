Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab3BZVrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:47:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24609 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3BZVrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:47:10 -0500
Date: Tue, 26 Feb 2013 13:45:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>
Cc: OS Engineering <osengineering@stec-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        =?utf-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>,
        Amit Kale <akale@stec-inc.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "koverstreet@google.com" <koverstreet@google.com>,
        "thornber@redhat.com" <thornber@redhat.com>
Subject: Re: [PATCH] EnhanceIO ssd caching software
Message-ID: <20130226214528.GC4059@blackbox.djwong.org>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6AAF@MYMBX.MY.STEC-INC.AD>
 <20130215203139.GE26292@blackbox.djwong.org>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B0C746B4948@MYMBX.MY.STEC-INC.AD>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B0C746B4948@MYMBX.MY.STEC-INC.AD>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 05:42:38PM +0800, Sanoj Unnikrishnan wrote:
> > -----Original Message-----
> > From: Darrick J. Wong [mailto:darrick.wong@oracle.com]
> > Sent: Saturday, February 16, 2013 2:02 AM
> > To: OS Engineering
> > Cc: Greg Kroah-Hartman; LKML; Jens Axboe; Sanoj Unnikrishnan; 王金浦;
> > Amit Kale; dm-devel@redhat.com; koverstreet@google.com;
> > thornber@redhat.com
> > Subject: Re: [PATCH] EnhanceIO ssd caching software
> > 
> > [Resending with dm-devel, Kent, and Joe on cc.  Sorry for the noise.]
> > 
> > On Fri, Feb 15, 2013 at 02:02:38PM +0800, OS Engineering wrote:
> > > Hi Greg, Jens,
> > >
> > > We are submitting EnhanceIO(TM) software driver for an inclusion in
> > linux
> > > staging tree. Present state of this driver is beta. We have been
> > posting it
> > > for a few weeks, while it was maintained at github. It is still being
> > > cleaned-up and is being tested by LKML members. Inclusion in linux
> > staging
> > > tree will make testing and reviewing easier and help a future
> > integration in
> > > Linux kernel.
> > >
> > > Could you please include it?
> 
> > >
> > > Signed-off-by:
> > > Amit Kale <akale@stec-inc.com>
> > > Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>
> > > Darrick J. Wong <darrick.wong@oracle.com>
> > > Jinpu Wang <jinpuwang@gmail.com>
> > 
> > Each of these email addresses needs to have the "S-o-b:" prefix
> 
> > Also, you ought to run this patch through scripts/checkpatch.pl, as
> > there are
> > quite a lot of style errors.
> 
> we will fix these in the next patch.
> 
> 
> > > +ACTION!="add|change", GOTO="EIO_EOF"
> > > +SUBSYSTEM!="block", GOTO="EIO_EOF"
> > > +
> > > +<cache_match_expr>, GOTO="EIO_CACHE"
> > > +
> > > +<source_match_expr>, GOTO="EIO_SOURCE"
> > > +
> > > +# If none of the rules above matched then it isn't an EnhanceIO
> > device so ignore it.
> > > +GOTO="EIO_EOF"
> > > +
> > > +# If we just found the cache device and the source already exists
> > then we can setup
> > > +LABEL="EIO_CACHE"
> > > +       TEST!="/dev/enhanceio/<cache_name>", PROGRAM="/bin/mkdir -p
> > /dev/enhanceio/<cache_name>"
> > > +       PROGRAM="/bin/sh -c 'echo $kernel >
> > /dev/enhanceio/<cache_name>/.ssd_name'"
> > > +
> > > +       TEST=="/dev/enhanceio/<cache_name>/.disk_name",
> > GOTO="EIO_SETUP"
> > > +GOTO="EIO_EOF"
> > > +
> > > +# If we just found the source device and the cache already exists
> > then we can setup
> > > +LABEL="EIO_SOURCE"
> > > +       TEST!="/dev/enhanceio/<cache_name>", PROGRAM="/bin/mkdir -p
> > /dev/enhanceio/<cache_name>"
> > > +       PROGRAM="/bin/sh -c 'echo $kernel >
> > /dev/enhanceio/<cache_name>/.disk_name'"
> > > +
> > > +       TEST=="/dev/enhanceio/<cache_name>/.ssd_name",
> > GOTO="EIO_SETUP"
> > 
> > If the cache is running in wb mode, perhaps we should make it ro until
> > the SSD
> > shows up and we run eio_cli?  Run blockdev --setro in the EIO_CACHE
> > part, and
> > blockdev --setrw in the EIO_SOURCE part?
> > 
> > <shrug> not a udev developer, take that with a grain of salt.
> 
> We were exploring hiding source node as an option. This seems to be better.
>  
> > > +How to create persistent cache
> > > +==============================
> > > +
> > > +Use the 94-Enhanceio-template file to create a per cache udev-rule
> > file named /etc/udev/rules.d/94-enhancio-<cache_name>.rules
> > > +
> > > +1) Change <cache_match_expr> to ENV{ID_SERIAL}=="<ID SERIAL OF YOUR
> > CACHE DEVICE>", ENV{DEVTYPE}==<DEVICE TYPE OF YOUR CACHE DEVICE>
> > > +
> > > +2) Change <source_match_expr> to ENV{ID_SERIAL}=="<ID SERIAL OF YOUR
> > HARD DISK>", ENV{DEVTYPE}==<DEVICE TYPE OF YOUR SOURCE DEVICE>
> > > +
> > > +3) Replace all instances of <cache_name> with the name of your cache
> > 
> > I wonder if there's a better way to do this than manually cutting and
> > pasting
> > all these IDs into a udev rules file.  Or, how about a quick script at
> > cache
> > creation time that spits out files into /etc/udev/rules.d/ ?
> 
> agreed!! Will add one in the next patch.
> 
> > > +       Write-back improves write latency by writing application
> > requested data
> > > +       only to SSD. This data, referred to as dirty data, is copied
> > later to
> > 
> > How much later?
> >
> 
> This is triggered by a set of thresholds.
> per cache dirty high and low watermark.
> per cache set dirty high and low watermark.
> and a time based threshold.
> If any of the high watermarks or time based interval is triggered clean is initiated.
> 
> These thresholds are all configurable through sysctl.

Is there a way for a user application to force a cache flush?  It looks as
though a REQ_FLUSH will cause both SSD and HDD to flush their write caches, but
I couldn't find anything that would suggest writing all the dirty blocks in the
cache out to the HDD.

--D
