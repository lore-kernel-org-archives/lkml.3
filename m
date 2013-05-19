Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3ESOoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 10:44:46 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55696 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab3ESOoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 10:44:44 -0400
Date: Sun, 19 May 2013 09:44:42 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] gru: fix a sanity test in gru_set_context_option()
Message-ID: <20130519144442.GA8926@sgi.com>
References: <20130519125950.GA17651@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130519125950.GA17651@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 03:59:50PM +0300, Dan Carpenter wrote:
> "req.val1 == -1" is valid but it doesn't make sense to check
> gru_base[-1].  gru_base[] is a global array.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
> index c4acac7..e7c37b2 100644
> --- a/drivers/misc/sgi-gru/grufault.c
> +++ b/drivers/misc/sgi-gru/grufault.c
> @@ -876,7 +876,8 @@ int gru_set_context_option(unsigned long arg)
>  	switch (req.op) {
>  	case sco_blade_chiplet:
>  		/* Select blade/chiplet for GRU context */
> -		if (req.val1 < -1 || req.val1 >= GRU_MAX_BLADES || !gru_base[req.val1] ||
> +		if (req.val1 < -1 || req.val1 >= GRU_MAX_BLADES ||
> +		    (req.val1 != -1 && !gru_base[req.val1]) ||
>  		    req.val0 < -1 || req.val0 >= GRU_CHIPLETS_PER_HUB) {
>  			ret = -EINVAL;
>  		} else {

Since we're here, maybe we should neaten this up a little?

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 drivers/misc/sgi-gru/grufault.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c
+++ linux/drivers/misc/sgi-gru/grufault.c
@@ -876,8 +876,9 @@ int gru_set_context_option(unsigned long
 	switch (req.op) {
 	case sco_blade_chiplet:
 		/* Select blade/chiplet for GRU context */
-		if (req.val1 < -1 || req.val1 >= GRU_MAX_BLADES || !gru_base[req.val1] ||
-		    req.val0 < -1 || req.val0 >= GRU_CHIPLETS_PER_HUB) {
+		if (req.val0 < -1 || req.val0 >= GRU_CHIPLETS_PER_HUB ||
+			req.val1 < -1 || req.val1 >= GRU_MAX_BLADES ||
+			(req.val1 >= 0 && !gru_base[req.val1])) {
 			ret = -EINVAL;
 		} else {
 			gts->ts_user_blade_id = req.val1;
