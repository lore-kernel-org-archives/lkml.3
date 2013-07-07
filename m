Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3GGA03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 20:26:29 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:58090 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3GGA01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 20:26:27 -0400
Message-ID: <1373157084.7397.73.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 3/3] target: make queue_tm_rsp() return void
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
Date: Sat, 06 Jul 2013 17:31:24 -0700
In-Reply-To: <1372864937-32437-4-git-send-email-joern@logfs.org>
References: <1372864937-32437-1-git-send-email-joern@logfs.org>
	 <1372864937-32437-4-git-send-email-joern@logfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 11:22 -0400, Joern Engel wrote:
> The return value wasn't checked by any of the callers.  Assuming this is
> correct behaviour, we can simplify some code by not bothering to
> generate it.
> 
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c        |   14 +++++---------
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c           |    4 +---
>  drivers/target/iscsi/iscsi_target_configfs.c |    3 +--
>  drivers/target/loopback/tcm_loop.c           |    3 +--
>  drivers/target/sbp/sbp_target.c              |    3 +--
>  drivers/target/tcm_fc/tcm_fc.h               |    2 +-
>  drivers/target/tcm_fc/tfc_cmd.c              |    5 ++---
>  drivers/usb/gadget/tcm_usb_gadget.c          |    3 +--
>  drivers/vhost/tcm_vhost.c                    |    3 +--
>  include/target/target_core_fabric.h          |    2 +-
>  10 files changed, 15 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index c09d41b..2c61a28 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2987,7 +2987,7 @@ static u8 tcm_to_srp_tsk_mgmt_status(const int tcm_mgmt_status)
>   * Callback function called by the TCM core. Must not block since it can be
>   * invoked on the context of the IB completion handler.
>   */
> -static int srpt_queue_response(struct se_cmd *cmd)
> +static void srpt_queue_response(struct se_cmd *cmd)
>  {
>  	struct srpt_rdma_ch *ch;
>  	struct srpt_send_ioctx *ioctx;
> @@ -2998,8 +2998,6 @@ static int srpt_queue_response(struct se_cmd *cmd)
>  	int resp_len;
>  	u8 srp_tm_status;
>  
> -	ret = 0;
> -
>  	ioctx = container_of(cmd, struct srpt_send_ioctx, cmd);
>  	ch = ioctx->ch;
>  	BUG_ON(!ch);
> @@ -3025,7 +3023,7 @@ static int srpt_queue_response(struct se_cmd *cmd)
>  		     || WARN_ON_ONCE(state == SRPT_STATE_CMD_RSP_SENT))) {
>  		atomic_inc(&ch->req_lim_delta);
>  		srpt_abort_cmd(ioctx);
> -		goto out;
> +		return;
>  	}
>  
>  	dir = ioctx->cmd.data_direction;
> @@ -3037,7 +3035,7 @@ static int srpt_queue_response(struct se_cmd *cmd)
>  		if (ret) {
>  			printk(KERN_ERR "xfer_data failed for tag %llu\n",
>  			       ioctx->tag);
> -			goto out;
> +			return;
>  		}
>  	}
>  
> @@ -3058,9 +3056,6 @@ static int srpt_queue_response(struct se_cmd *cmd)
>  		srpt_set_cmd_state(ioctx, SRPT_STATE_DONE);
>  		target_put_sess_cmd(ioctx->ch->sess, &ioctx->cmd);
>  	}
> -
> -out:
> -	return ret;
>  }
>  
>  static int srpt_queue_status(struct se_cmd *cmd)
> @@ -3073,7 +3068,8 @@ static int srpt_queue_status(struct se_cmd *cmd)
>  	    (SCF_TRANSPORT_TASK_SENSE | SCF_EMULATED_TASK_SENSE))
>  		WARN_ON(cmd->scsi_status != SAM_STAT_CHECK_CONDITION);
>  	ioctx->queue_status_only = true;
> -	return srpt_queue_response(cmd);
> +	srpt_queue_response(cmd);
> +	return 0;
>  }
>  
>  static void srpt_refresh_port_work(struct work_struct *work)

Hi Joern,

This one doesn't quite work for ib_srpt code, as srpt_queue_response()
is used by TFO->queue_data_in() and expects a return value here..

Squashing the following fix on top of your original patch into for-next
now.

Thanks!

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 59319c6..653ac6b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3082,6 +3082,17 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	}
 }
 
+static int srpt_queue_data_in(struct se_cmd *cmd)
+{
+	srpt_queue_response(cmd);
+	return 0;
+}
+
+static void srpt_queue_tm_rsp(struct se_cmd *cmd)
+{
+	srpt_queue_response(cmd);
+}
+
 static int srpt_queue_status(struct se_cmd *cmd)
 {
 	struct srpt_send_ioctx *ioctx;
@@ -3926,9 +3937,9 @@ static struct target_core_fabric_ops srpt_template = {
 	.set_default_node_attributes	= srpt_set_default_node_attrs,
 	.get_task_tag			= srpt_get_task_tag,
 	.get_cmd_state			= srpt_get_tcm_cmd_state,
-	.queue_data_in			= srpt_queue_response,
+	.queue_data_in			= srpt_queue_data_in,
 	.queue_status			= srpt_queue_status,
-	.queue_tm_rsp			= srpt_queue_response,
+	.queue_tm_rsp			= srpt_queue_tm_rsp,
 	/*
 	 * Setup function pointers for generic logic in
 	 * target_core_fabric_configfs.c

