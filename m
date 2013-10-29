Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab3J2Hdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:33:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17769 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3J2Hdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:33:40 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-3c-526f64c84e1d
From: "shifei10.ge" <shifei10.ge@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: "'??'" <shu.tan@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <27929860.72301382948116848.JavaMail.weblogic@epml07>
 <1382955704.992.91.camel@kjgkr>
In-reply-to: <1382955704.992.91.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs:fix truncate_partial_nodes bug
Date: Tue, 29 Oct 2013 15:32:34 +0800
Message-id: <000101ced479$26555160$72fff420$%ge@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7Tx5YR8jAAd+oUQv+Ur1++5QETBgAric7w
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jAd0TKflBBhPPCltc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxvzb/UwF
	ewwrDt94yd7AuFeti5GTQ0LARGLBnb9MELaYxIV769m6GLk4hAQWMUo8+nOIEcL5zSjRdu0Y
	C0gVm4CuxPojn8E6RASkJWZ9mscCUsQs0MooMXPdKTaQhJBAssT9x5vAijgFdCQ2vZ4IFhcW
	cJbYsXsO2CAWAVWJ9bOeMYLYvAI2EtNWdzFD2IISPybfA6rhABqqLjFlSi5ImFlAW+LJuwus
	IGEJoPCjv7oQJxhJ9P/Zzg5RIi4x6cFD9gmMQrOQDJqFMGgWkkGzkHQsYGRZxSiaWpBcUJyU
	nmukV5yYW1yal66XnJ+7iREcAc+kdzCuarA4xCjAwajEw2vBlh8kxJpYVlyZe4hRgoNZSYR3
	RzBQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2PX19Yt
	roKZDxed2MAr13s0PM1tdhyfo+ShSw/bPWff97sTyjhRIvdLuqXRjOrDWlp63jaiqg+O2/w5
	nmuXtv6ZYOnp0kkbOfhmnJ5VLL7m4VTPjK2v7j6Zryz8qfjd9reXxG4yvWmSLWav6dz+2afw
	GV/ZXql7xX/kQxcdSzqxc57tgQXi2leUWIozEg21mIuKEwHfA7IwfAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,I think we don't need to put the invalid page that get_node_page returned.
So I add " idx = i--" based on your version.Following is the patch: 

---
 fs/f2fs/node.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 304d5ce..fd5f721 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -631,19 +631,19 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 		return 0;
 
 	/* get indirect nodes in the path */
-	for (i = 0; i < depth - 1; i++) {
+	for (i = 0; i < idx + 1; i++) {
 		/* refernece count'll be increased */
 		pages[i] = get_node_page(sbi, nid[i]);
 		if (IS_ERR(pages[i])) {
-			depth = i + 1;
 			err = PTR_ERR(pages[i]);
+			idx = i--;
 			goto fail;
 		}
 		nid[i + 1] = get_nid(pages[i], offset[i + 1], false);
 	}
 
 	/* free direct nodes linked to a partial indirect node */
-	for (i = offset[depth - 1]; i < NIDS_PER_BLOCK; i++) {
+	for (i = offset[idx + 1]; i < NIDS_PER_BLOCK; i++) {
 		child_nid = get_nid(pages[idx], i, false);
 		if (!child_nid)
 			continue;
@@ -654,7 +654,7 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 		set_nid(pages[idx], i, 0, false);
 	}
 
-	if (offset[depth - 1] == 0) {
+	if (offset[idx + 1] == 0) {
 		dn->node_page = pages[idx];
 		dn->nid = nid[idx];
 		truncate_node(dn);
@@ -662,9 +662,10 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 		f2fs_put_page(pages[idx], 1);
 	}
 	offset[idx]++;
-	offset[depth - 1] = 0;
+	offset[idx + 1] = 0;
+	idx--;
 fail:
-	for (i = depth - 3; i >= 0; i--)
+	for (i = idx; i >= 0; i--)	
 		f2fs_put_page(pages[i], 1);
 
 	trace_f2fs_truncate_partial_nodes(dn->inode, nid, depth, err);
-- 
1.7.9.5


> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, October 28, 2013 6:22 PM
> To: shifei10.ge@samsung.com
> Cc: ??; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH] f2fs:fix truncate_partial_nodes bug
> 
> Hi,
> 
> 2013-10-28 (월), 08:15 +0000, Shifei Ge:
> > truncate_partial_nodes puts pages incorrectly in two cases.note that the
> value for argc 'depth' can only be 2 or 3(see truncate_inode_blocks ---
> >truncate_partial_nodes ).
> > first case:err happened in the first 'for' loop
> > 	assume depth is 2,when err happened,pages[0] is invalid,so this page
> don't need to be put when func return,there is no problem.
> > 	but when depth is 3 ,pages isn't put correctly when pages[0] is valid
> and pages[1] is invalid.in this case,depth is set to 2(ref to statemnt depth =
> i + 1) ,and then 'goto fail'.
> > 	in label 'fail', for (i = depth - 3; i >= 0; i--) cann't meet the
> condition because i=-1,so pages[0] cann't be put when func return.
> > second case:err happened in the second 'for' loop
> > 	now,we've got pages[0] with argc 'depth' is 2 ,or we've got pages[0]
> and pages[1] with depth is 3.when err happend,we need 'goto fail' to put pages
> we've got.
> > 	when depth is 2,in label 'fail',for (i = depth - 3; i >= 0; i--) cann't
> meet the condition because i=-1,so pages[0] cann't be put.
> > 	when depth is 3,in label 'fail',for (i = depth - 3; i >= 0; i--) can
> only put pages[0],pages[1] also cann't be put.
> > notes 'depth' has been changed before first 'goto fail'(ref to statemnt
> depth = i + 1),so pass this modified 'depth' to
> trace_f2fs_truncate_partial_nodes is also incorrectly.
> 
> Please write a description not to exceed 80 columns.
> It's very hard to understand.
> 
> >
> > From 9de8efa31759ce86a032f5ad092d337b686ede06 Mon Sep 17 00:00:00 2001
> > Signed-off-by: Shifei Ge <shifei10.ge@samsung.com>
> > ---
> >  fs/f2fs/node.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c index 304d5ce..9986930
> > 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -625,6 +625,7 @@ static int truncate_partial_nodes(struct dnode_of_data
> *dn,
> >  	int err = 0;
> >  	int i;
> >  	int idx = depth - 2;
> > +	int dep = depth;
> 
> I think we need to avoid using a local variable only for the use of
> tracepoints below.
> How about this?
> 
> ---
>  fs/f2fs/node.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c index 304d5ce..8578719 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -631,11 +631,10 @@ static int truncate_partial_nodes(struct dnode_of_data
> *dn,
>  		return 0;
> 
>  	/* get indirect nodes in the path */
> -	for (i = 0; i < depth - 1; i++) {
> +	for (i = 0; i < idx + 1; i++) {
>  		/* refernece count'll be increased */
>  		pages[i] = get_node_page(sbi, nid[i]);
>  		if (IS_ERR(pages[i])) {
> -			depth = i + 1;
>  			err = PTR_ERR(pages[i]);
>  			goto fail;
>  		}
> @@ -643,7 +642,7 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
>  	}
> 
>  	/* free direct nodes linked to a partial indirect node */
> -	for (i = offset[depth - 1]; i < NIDS_PER_BLOCK; i++) {
> +	for (i = offset[idx + 1]; i < NIDS_PER_BLOCK; i++) {
>  		child_nid = get_nid(pages[idx], i, false);
>  		if (!child_nid)
>  			continue;
> @@ -654,7 +653,7 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
>  		set_nid(pages[idx], i, 0, false);
>  	}
> 
> -	if (offset[depth - 1] == 0) {
> +	if (offset[idx + 1] == 0) {
>  		dn->node_page = pages[idx];
>  		dn->nid = nid[idx];
>  		truncate_node(dn);
> @@ -662,9 +661,10 @@ static int truncate_partial_nodes(struct dnode_of_data
> *dn,
>  		f2fs_put_page(pages[idx], 1);
>  	}
>  	offset[idx]++;
> -	offset[depth - 1] = 0;
> +	offset[idx + 1] = 0;
> +	idx--;
>  fail:
> -	for (i = depth - 3; i >= 0; i--)
> +	for (i = idx; i >= 0; i--)
>  		f2fs_put_page(pages[i], 1);
> 
>  	trace_f2fs_truncate_partial_nodes(dn->inode, nid, depth, err);
> --
> 1.8.4.474.g128a96c
> 
> 
> 
> 
> --
> Jaegeuk Kim
> Samsung

