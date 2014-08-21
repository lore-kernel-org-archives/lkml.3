Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaHUDFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 23:05:20 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:51627 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaHUDFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 23:05:18 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: Revert "platform/x86/toshiba-apci.c possible bad if test?"
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20140820235354.67516660E82@gitolite.kernel.org>
Date: Thu, 21 Aug 2014 04:05:14 +0100
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <979CCE59-6BA9-4319-8F7C-4818FD2DB8F2@cam.ac.uk>
References: <20140820235354.67516660E82@gitolite.kernel.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

There is no doubt that the revert was needed but I think the original check which is now reinstated is also wrong.

I do not know what the intention actually is so cannot say what the correct check is but just logically speaking the check makes no sense:

	if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))

The condition "(mode != 2 || mode != 1)" will always be true given that mode can only have a single value: if mode == 1 then mode != 2 is true and thus the condition is true and vice versa if mode == 2 then mode != 1 is true and thus the condition is true, too.  And if mode is neither 1 nor 2 then both mode != 2 and mode != 1 are true and thus the condition is true, too.  Thus no matter what value "mode" has, the condition is true thus there is no point in it being there thus the if clause is exactly the same as:

	if (sscanf(buf, "%i", &mode) != 1)

Presumably that was not the original intention...

Perhaps the intention was to check that mode is either 1 or 2 and other values are not allowed?  If so the correct statement would be:

	if (sscanf(buf, "%i", &mode) != 1 || (mode != 2 && mode != 1))

But as I said above I do not know if that was the original intention but it looks like that this may have been the intention...

Best regards,

	Anton

On 21 Aug 2014, at 00:53, Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/linus/;a=commit;h=8039aabb6c9f802bca04cc77ca210060a5b53916
> Commit:     8039aabb6c9f802bca04cc77ca210060a5b53916
> Parent:     186e4e89a0922d75fba476f15b723e541cc34bea
> Refname:    refs/heads/master
> Author:     Matthew Garrett <matthew.garrett@nebula.com>
> AuthorDate: Wed Aug 20 08:18:18 2014 -0700
> Committer:  Matthew Garrett <matthew.garrett@nebula.com>
> CommitDate: Wed Aug 20 08:18:18 2014 -0700
> 
>    Revert "platform/x86/toshiba-apci.c possible bad if test?"
> 
>    This reverts commit bdc3ae7221213963f438faeaa69c8b4a2195f491.
> 
>    Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
> drivers/platform/x86/toshiba_acpi.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index e4da61b..b062d3d 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -1258,7 +1258,7 @@ static ssize_t toshiba_kbd_bl_mode_store(struct device *dev,
> 	int mode = -1;
> 	int time = -1;
> 
> -	if (sscanf(buf, "%i", &mode) != 1  || (mode != 2 || mode != 1))
> +	if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
> 		return -EINVAL;
> 
> 	/* Set the Keyboard Backlight Mode where:
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

