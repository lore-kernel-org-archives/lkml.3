Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab3AQDRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:17:45 -0500
Received: from ihemail1.lucent.com ([135.245.0.33]:57593 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab3AQDRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 22:17:43 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jan 2013 22:17:43 EST
Date: Wed, 16 Jan 2013 21:06:49 -0600 (CST)
From: Ilija Hadzic <ihadzic@research.bell-labs.com>
X-X-Sender: ihadzic@umail
To: Shuah Khan <shuah.khan@hp.com>
cc: airlied@linux.ie, deathsimple@vodafone.de, jglisse@redhat.com,
        airlied@redhat.com, "Deucher, Alexander" <alexander.deucher@amd.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH] drm/radeon: fix NULL pointer dereference in UMS mode in
 radeon_cs_parser_fini()
In-Reply-To: <1358379788.7243.10.camel@lorien2>
Message-ID: <Pine.GSO.4.64.1301162045321.898@umail>
References: <1358379788.7243.10.camel@lorien2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Actually, the code path affected by your patch is not executed in UMS mode 
at all. Notice that radeon_cs_parser_fini is only called from 
radeon_cs_ioctl which is a KMS-only ioctl (see radeon_kms.c).

The equivalent of the fix you are trying to do is in
a6b7e1a02b77ab8fe8775d20a88c53d8ba55482e (function patched by that one is 
the one used by legacy-CS ioctl), which you should go together 
with ff4bd0827764e10a428a9d39e6814c5478863f94 if you are backporting UMS 
fixes to 3.7. Both are needed to prevent kernel crashes in UMS mode.

-- Ilija

On Wed, 16 Jan 2013, Shuah Khan wrote:

> Fix parser->rdev NULL pointer dereference in radeon_cs_parser_fini().
> While back-porting drm/radeon: fix NULL pointer dereference in UMS mode
> patch (commit-id: ff4bd0827764e10a428a9d39e6814c5478863f94) to 3,7.y, noticed
> another instance of NULL pointer dereference in radeon_cs_parser_fini()
> function.
>
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> CC: stable@vger.kernel.org 3.7
> ---
> drivers/gpu/drm/radeon/radeon_cs.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
> index 469661f..d1c282c 100644
> --- a/drivers/gpu/drm/radeon/radeon_cs.c
> +++ b/drivers/gpu/drm/radeon/radeon_cs.c
> @@ -329,7 +329,7 @@ static void radeon_cs_parser_fini(struct radeon_cs_parser *parser, int error)
> 	kfree(parser->relocs_ptr);
> 	for (i = 0; i < parser->nchunks; i++) {
> 		kfree(parser->chunks[i].kdata);
> -		if ((parser->rdev->flags & RADEON_IS_AGP)) {
> +		if (parser->rdev && (parser->rdev->flags & RADEON_IS_AGP)) {
> 			kfree(parser->chunks[i].kpage[0]);
> 			kfree(parser->chunks[i].kpage[1]);
> 		}
> -- 
> 1.7.9.5
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
