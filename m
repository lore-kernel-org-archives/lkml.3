Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaKKGCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:02:49 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaKKGCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:02:48 -0500
Date: Mon, 10 Nov 2014 22:02:43 -0800
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] dell-wmi: Update code for processing WMI events
Message-ID: <20141111060243.GC56947@vmdeb7>
References: <1413843324-13662-1-git-send-email-pali.rohar@gmail.com>
 <20141021213212.GE20951@vmdeb7>
 <201410221251.17977@pali>
 <201411091621.35634@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411091621.35634@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 04:21:33PM +0100, Pali Rohár wrote:
> On Wednesday 22 October 2014 12:51:17 Pali Rohár wrote:
> > On Tuesday 21 October 2014 23:32:12 Darren Hart wrote:
> > > On Tue, Oct 21, 2014 at 12:15:24AM +0200, Pali Rohár wrote:

Hi Pali,

...
> > > > @@ -158,44 +182,117 @@ static void dell_wmi_notify(u32
> > > > value, void *context)
> > > > 
> > > >  	}
> > > >  	
> > > >  	obj = (union acpi_object *)response.pointer;
> > > > 
> > > > +	if (!obj) {
> > > > +		pr_info("no response\n");
> > > > +		return;
> > > > +	}
> > > 
> > > If you intend to print this, it should probably be a bit
> > > more informative. Is "info" the right level here? I would
> > > imagine either WARN if this was a bad thing, or DEBUG if
> > > this is more for debugging the driver.
> > 
> > So what you (or somebody else) prefer? warn or debug?

I was leaving that up to you based on your interpretation of severity and why
you added this. If it was just for debug purporses, the I suggest debug. If this
will impact the user in an unexpected way, then WARN.

...
> > > > +	if (!dell_new_hk_type) {
> > > > +		if (buffer_size >= 3 && buffer_entry[1] == 0x0)
> > > > +			dell_wmi_process_key(buffer_entry[2]);
> > > > 
> > > >  		else if (buffer_size >= 2)
> > > > 
> > > > -			reported_key = (int)buffer_entry[1] & 0xffff;
> > > > -		else {
> > > > +			dell_wmi_process_key(buffer_entry[1]);
> > > 
> > > Why can we drop the 0xffff mask now?
> > 
> > Because it is useless (or correct me if not!). Variable
> > buffer_entry has type u16* so operation "AND 0xFFFF" on 16bit
> > integer do nothing.

Right, of course. Thanks,

> > > > +		else
> > > > 
> > > >  			pr_info("Received unknown WMI event\n");
> > > > 
> > > > -			kfree(obj);
> > > > -			return;
> > > > +		kfree(obj);
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	buffer_end = buffer_entry + buffer_size;
> > > > +
> > > > +	while (buffer_entry < buffer_end) {
> > > > +
> > > > +		len = buffer_entry[0];
> > > > +		if (len == 0)
> > > > +			break;
> > > > +
> > > > +		len++;
> > > > +
> > > 
> > > Why increment len here? Are you trying to avoid a "len + 1"
> > > in the comparisons below? If so, is using "len * 2" in the
> > > debug message below correct? Please clarify.
> > 
> > in buffer_entry[0] (16 bit integer) is stored length of event
> > (in 16bit units) without first (length) value. And "%*ph"
> > takes size in bytes (u8). So length in bytes (u8) units is 2
> > * length in u16 units.

Right, got it - thanks.

> > > > +		if (buffer_entry+len > buffer_end) {
> > > 
> > > See coding style documentation on operators. Please run
> > > patches through checkpatch.
> > 
> > checkpatch.pl does not show any problem for these lines.

I thought we checked for that. Please see Documentation/CodingStyle 3.1: Spaces
with regard to spacing around binary and ternary operators. (one space on each
side of).

> Darren: PING. See my comments and questions.

Thanks for the ping :)

So please choose a loglevel and correct the whitespace and we should be good.

-- 
Darren Hart
Intel Open Source Technology Center
