Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaGSSAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 14:00:34 -0400
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:44056 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932192AbaGSSAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 14:00:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:69:355:379:541:599:800:877:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2731:2828:2895:2898:3138:3139:3140:3141:3142:3354:3865:3867:3868:3871:3872:4250:4321:4385:4434:5007:6119:7514:7652:7901:7903:10004:10400:10848:11026:11232:11658:1
X-HE-Tag: song23_78bd89c6e5b1e
X-Filterd-Recvd-Size: 4171
Message-ID: <1405792828.14358.110.camel@joe-AO725>
Subject: Re: [PATCH 2/4] staging: sep: No else is necessary after a break
 (reported by checkpatch)
From: Joe Perches <joe@perches.com>
To: LABBE Corentin <clabbe.montjoie@gmail.com>, mark.a.allyn@intel.com,
        jayant.mangalampalli@intel.com
Cc: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        paul.gortmaker@windriver.com, jg1.han@samsung.com,
        paulmck@linux.vnet.ibm.com, valentina.manea.m@gmail.com, jack@suse.cz,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 19 Jul 2014 11:00:28 -0700
In-Reply-To: <1405791282-28023-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1405791282-28023-1-git-send-email-clabbe.montjoie@gmail.com>
	 <1405791282-28023-3-git-send-email-clabbe.montjoie@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Mark Allyn and Jayant Mangalampalli)

Is this still project still active?

On Sat, 2014-07-19 at 19:34 +0200, LABBE Corentin wrote:
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  drivers/staging/sep/sep_main.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
> index 177e4b9..1580d95f 100644
> --- a/drivers/staging/sep/sep_main.c
> +++ b/drivers/staging/sep/sep_main.c
> @@ -2881,12 +2881,11 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
>  				if (is_kva) {
>  					error = -ENODEV;
>  					break;
> -				} else {
> -					error_temp = copy_to_user(
> +				}
> +				error_temp = copy_to_user(
>  						(void __user *)tail_pt,
>  						dcb_table_ptr->tail_data,
>  						dcb_table_ptr->tail_data_size);
> -				}
>  				if (error_temp) {
>  					/* Release the DMA resource */
>  					error = -EFAULT;

It'd be probably be better to rewrite the code to unindent
a level by using continue.  Something like below:

btw:

the is_kva test looks very odd and should probably be
moved outside the loop.

pt_hold should probably be void * not unsigned long
as it loses high order bits on x86-32.

definition:
	aligned_u64 out_vr_tail_pt;
use:
+			pt_hold = (unsigned long)dcb_table_ptr->
+				out_vr_tail_pt;

---
 drivers/staging/sep/sep_main.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 75ca15e..24b4a54 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -2871,26 +2871,23 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 		 * Go over each DCB and see if
 		 * tail pointer must be updated
 		 */
-		for (i = 0; i < (*dma_ctx)->nr_dcb_creat;
-		     i++, dcb_table_ptr++) {
-			if (dcb_table_ptr->out_vr_tail_pt) {
-				pt_hold = (unsigned long)dcb_table_ptr->
-					out_vr_tail_pt;
-				tail_pt = (void *)pt_hold;
-				if (is_kva) {
-					error = -ENODEV;
-					break;
-				} else {
-					error_temp = copy_to_user(
-						(void __user *)tail_pt,
-						dcb_table_ptr->tail_data,
-						dcb_table_ptr->tail_data_size);
-				}
-				if (error_temp) {
-					/* Release the DMA resource */
-					error = -EFAULT;
-					break;
-				}
+		for (i = 0; i < (*dma_ctx)->nr_dcb_creat; i++, dcb_table_ptr++) {
+			if (!dcb_table_ptr->out_vr_tail_pt)
+				continue;
+			pt_hold = (unsigned long)dcb_table_ptr->
+				out_vr_tail_pt;
+			tail_pt = (void *)pt_hold;
+			if (is_kva) {
+				error = -ENODEV;
+				break;
+			}
+			error_temp = copy_to_user((void __user *)tail_pt,
+						  dcb_table_ptr->tail_data,
+						  dcb_table_ptr->tail_data_size);
+			if (error_temp) {
+				/* Release the DMA resource */
+				error = -EFAULT;
+				break;
 			}
 		}
 	}


