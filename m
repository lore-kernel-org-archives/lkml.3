Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab3CBWfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 17:35:34 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:57906 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970Ab3CBWfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 17:35:33 -0500
Message-ID: <1362263724.1334.18.camel@x61.thuisdomein>
Subject: Re: [ 34/77] xen/blkback: Dont trust the handle from the frontend.
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Sat, 02 Mar 2013 23:35:24 +0100
In-Reply-To: <1362253682.3768.136.camel@deadeye.wl.decadent.org.uk>
References: <20130301194351.913471337@linuxfoundation.org>
	 <20130301194355.578429064@linuxfoundation.org>
	 <1362172344.20156.15.camel@x61.thuisdomein>
	 <1362253682.3768.136.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Mar 2013 22:35:25.0167 (UTC) FILETIME=[3B88AFF0:01CE1796]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 19:48 +0000, Ben Hutchings wrote:
> When gcc compiles something like this:
> 
> static int foo(int *p)
> {
> 	if (rand() & 1)
> 		return -1;
> 	*p = 0;
> 	return 0;
> }
> 
> int bar(void)
> {
> 	int i;
> 	if (foo(&i) < 0)
> 		return 1;
> 	return i;
> }
> 
> and inlines foo() into bar(), sometimes it fails to recognise that i
> will definitely be initialised before use.  This simple example seems to
> be OK but more complex functions such as these will often trigger this
> warning.  The warning is really quite useless now.

0) I've had another look at the relevant code in v3.8.2-rc1. It can be
summarized like this:

static int xen_vbd_translate()
{
	[...]
	int rc = -EACCES;

	if ([...])
		goto out;
	[...]

	[p]req->dev  = vbd->pdevice;
	[p]req->bdev = vbd->bdev;
	[...]

 out:
	return rc;
}

static int dispatch_rw_block_io()
{
	struct phys_req preq;
	[...]

	preq.sector_number = req->u.rw.sector_number;
	preq.nr_sects      = 0;
	[...]

	for ([...]) {
		[...]
		preq.nr_sects += seg[i].nsec;
	}

	if (xen_vbd_translate(&preq, blkif, operation) != 0) {
		pr_debug(DRV_PFX "access denied: %s of [%llu,%llu] on dev=%04x\n",
			 operation == READ ? "read" : "write",
			 preq.sector_number,
			 preq.sector_number + preq.nr_sects, preq.dev);
		goto [...];
	}
	[...]
}

1) So if xen_vbd_translate() fails, it can return before setting
preq.dev. That makes the call of pr_debug() use an uninitialized value,
doesn't it? Does inlining xen_vbd_translate() and/or
dispatch_rw_block_io() generate code were that can't happen anymore?
(Both functions being static they probably are inlined.)

2) And even if inlining does generate code where this can't happen,
isn't it enough that preq.dev can be used uninitialized if no code were
inlined?


Paul Bolle

