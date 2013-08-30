Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3H3MSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:18:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab3H3MSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:18:07 -0400
Message-ID: <52208D7C.8000009@suse.de>
Date: Fri, 30 Aug 2013 14:18:04 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marcus Meissner <meissner@suse.de>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH: scsi: make scsi reset permissions more relaxed (RFC)
References: <20130830120450.GB31120@suse.de>
In-Reply-To: <20130830120450.GB31120@suse.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 02:04 PM, Marcus Meissner wrote:
> Hi folks,
> 
> cdrecord wants to whack the CD drive with a SCSI RESET ...
> 
> So far SCSI RESET can be done at 4 levels (target, device, bus, host)
> and all 4 are checked for CAP_SYS_ADMIN / CAP_SYS_RAWIO.
> 
> 
> As the cdrecord author wants special permissions for cdrecord, readcd ,
> cdda2wav to allow it to send SCSI RESET commands I was wondering if
> relaxing the permission is a potential idea?
> 
> This would allow SCSI reset on target/device if a local user
> gets regular access to a SCSI device (via udev acls etc.)
> 
Hmm. Device and target reset are typically implemented at the
transport level (SCSI itself doesn't have any commands for this).
So it should be possible to inject them via bsg, and as such should
have the same restrictions as bsg has.
Assuming that sg and bsg follow the same rules the patch should be okay.

> 
> (I know that the actual reset code will fall back into the chain
>  target -> device -> bus -> host resetting if one fails.)
> 
Actually, it doesn't. sg_reset_provider() will just call the
individual function.

If the function fails _and_ there are commands send to the device
then the error handling will kick in, but it won't be triggered
directly.
Not sure if that makes a difference, though.

> Signed-off-by: Marcus Meissner <meissner@suse.de>
> 
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
