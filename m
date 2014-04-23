Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbaDWIFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:05:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51167 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbaDWIFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:05:07 -0400
Date: Wed, 23 Apr 2014 11:04:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michalis Pappas <mpappas@fastmail.fm>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] staging: gdm72xx: Minor cleanup
Message-ID: <20140423080447.GS26890@mwanda>
References: <532BF9B0.2080008@fastmail.fm>
 <20140418225229.GA28077@kroah.com>
 <53534051.2020504@fastmail.fm>
 <53534116.3040705@fastmail.fm>
 <20140422093743.GC26890@mwanda>
 <53570BAA.3080709@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53570BAA.3080709@fastmail.fm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 08:39:06AM +0800, Michalis Pappas wrote:
> After all patches have been applied, the only remaining issue on the
> TODO list is to conform to the coding standards.  The remaining issues
> reported by checkpatch.pl are probably pedantic, so if agreed, that
> task can be removed from the list too.

So I did a:
for i in $(find drivers/staging/gdm72xx/ -name \*.c) ; do ./scripts/checkpatch.pl --strict -f $i 2>&1 ; done | tee err-list

I didn't look through all the issues but the ones I looked at seemed
valid.  The "no space after a cast" rule is good because cast precedence
used to be a common source of bugs.

The code in extract_qos_list() was badly mangled to get around the 80
character limit and checkpatch.pl finds that.  That function is very
ugly.  Just reverse the if statements instead of jamming the code up
								against
								the
								far
								right
								side of
								the
								screen.

		if (!qcb->csr[i].enabled)
			continue;
		if (qcb->csr[i].qos_buf_count >= qcb->qos_limit_size)
			continue;
		if (list_empty(&qcb->qos_list[i]))
			continue;

Also why is returning a u32?  Kernel style is int.  But this doesn't
return errors and the callers don't check so it should be void.  This
driver suffers from prefering u32 over int in many places.

This was my only static checker warning (harmless):
drivers/staging/gdm72xx/gdm_wimax.c:780 gdm_wimax_transmit_pkt()
	warn: we tested 'len' before and it was 'true'

In gdm_usb_send(), the "BUG_ON(len > TX_BUF_SIZE - padding - 1);" should
be proper error handling.

I didn't really do a proper review of this code when I saw all the
checkpatch.pl complaints still.

regards,
dan carpenter

