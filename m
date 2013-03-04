Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab3CDOsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:48:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113Ab3CDOsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:48:07 -0500
Subject: Re: [PATCH 1/2] gfs2: fix bitmap declaration
From: Steven Whitehouse <swhiteho@redhat.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        cluster-devel@redhat.com
In-Reply-To: <1362234695-5339-1-git-send-email-akinobu.mita@gmail.com>
References: <1362234695-5339-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 04 Mar 2013 14:46:32 +0000
Message-ID: <1362408392.2684.31.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Both patches now in the GFS2 -nmw tree. Thanks,

Steve.

On Sat, 2013-03-02 at 23:31 +0900, Akinobu Mita wrote:
> The bitmap accessed by bitops like set_bit_le and clear_bit_le must
> be aligned to the size of an "unsigned long".  But there are bitmaps
> that are declared as char array.
> 
> This converts these bitmaps to properly declared ones.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> ---
>  fs/gfs2/lock_dlm.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
> index 9802de0..ead5b36 100644
> --- a/fs/gfs2/lock_dlm.c
> +++ b/fs/gfs2/lock_dlm.c
> @@ -464,7 +464,7 @@ static void gdlm_cancel(struct gfs2_glock *gl)
>  #define JID_BITMAP_OFFSET 8 /* 4 byte generation number + 4 byte unused */
>  
>  static void control_lvb_read(struct lm_lockstruct *ls, uint32_t *lvb_gen,
> -			     char *lvb_bits)
> +			     void *lvb_bits)
>  {
>  	uint32_t gen;
>  	memcpy(lvb_bits, ls->ls_control_lvb, GDLM_LVB_SIZE);
> @@ -473,7 +473,7 @@ static void control_lvb_read(struct lm_lockstruct *ls, uint32_t *lvb_gen,
>  }
>  
>  static void control_lvb_write(struct lm_lockstruct *ls, uint32_t lvb_gen,
> -			      char *lvb_bits)
> +			      void *lvb_bits)
>  {
>  	uint32_t gen;
>  	memcpy(ls->ls_control_lvb, lvb_bits, GDLM_LVB_SIZE);
> @@ -481,11 +481,11 @@ static void control_lvb_write(struct lm_lockstruct *ls, uint32_t lvb_gen,
>  	memcpy(ls->ls_control_lvb, &gen, sizeof(uint32_t));
>  }
>  
> -static int all_jid_bits_clear(char *lvb)
> +static int all_jid_bits_clear(void *lvb)
>  {
>  	int i;
>  	for (i = JID_BITMAP_OFFSET; i < GDLM_LVB_SIZE; i++) {
> -		if (lvb[i])
> +		if (((char *)lvb)[i])
>  			return 0;
>  	}
>  	return 1;
> @@ -580,7 +580,7 @@ static void gfs2_control_func(struct work_struct *work)
>  {
>  	struct gfs2_sbd *sdp = container_of(work, struct gfs2_sbd, sd_control_work.work);
>  	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
> -	char lvb_bits[GDLM_LVB_SIZE];
> +	DECLARE_BITMAP(lvb_bits, GDLM_LVB_SIZE * BITS_PER_BYTE);
>  	uint32_t block_gen, start_gen, lvb_gen, flags;
>  	int recover_set = 0;
>  	int write_lvb = 0;
> @@ -758,7 +758,7 @@ static void gfs2_control_func(struct work_struct *work)
>  static int control_mount(struct gfs2_sbd *sdp)
>  {
>  	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
> -	char lvb_bits[GDLM_LVB_SIZE];
> +	DECLARE_BITMAP(lvb_bits, GDLM_LVB_SIZE * BITS_PER_BYTE);
>  	uint32_t start_gen, block_gen, mount_gen, lvb_gen;
>  	int mounted_mode;
>  	int retries = 0;
> @@ -949,7 +949,7 @@ static int dlm_recovery_wait(void *word)
>  static int control_first_done(struct gfs2_sbd *sdp)
>  {
>  	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
> -	char lvb_bits[GDLM_LVB_SIZE];
> +	DECLARE_BITMAP(lvb_bits, GDLM_LVB_SIZE * BITS_PER_BYTE);
>  	uint32_t start_gen, block_gen;
>  	int error;
>  


