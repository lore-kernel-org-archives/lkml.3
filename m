Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab3GGArz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 20:47:55 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:51721 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GGArx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 20:47:53 -0400
Message-ID: <1373158365.7397.92.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 1/3] target: remove iscsit_find_cmd_from_itt_or_dump()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
Date: Sat, 06 Jul 2013 17:52:45 -0700
In-Reply-To: <1372864937-32437-2-git-send-email-joern@logfs.org>
References: <1372864937-32437-1-git-send-email-joern@logfs.org>
	 <1372864937-32437-2-git-send-email-joern@logfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 11:22 -0400, Joern Engel wrote:
> Code is a copy of iscsit_find_cmd_from_itt().  Afaics this is debug code
> from at least two years ago.  Either the bug in question has been long
> fixed or this debug code doesn't help fixing it.  Whichever way you look
> at it, we should remove the debug code.
> 
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---

NAK on this one.

iscsit_handle_data_out() is expected to dump the incoming per
ISCSI_OP_SCSI_DATA_OUT payload for allowing existing code to determine
the next PDU header to process after this specific 'ITT not found'
exception case occurs.

Otherwise, the traditional iscsi connection will need to be reset when
the remaining DATA_OUT payload_length is not cleared from conn_sock.

--nab

>  drivers/target/iscsi/iscsi_target.c      |    3 +--
>  drivers/target/iscsi/iscsi_target_util.c |   24 ------------------------
>  drivers/target/iscsi/iscsi_target_util.h |    2 --
>  3 files changed, 1 insertion(+), 28 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 7ea246a..49346b3 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1213,8 +1213,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
>  					buf, conn);
>  	}
>  
> -	cmd = iscsit_find_cmd_from_itt_or_dump(conn, hdr->itt,
> -			payload_length);
> +	cmd = iscsit_find_cmd_from_itt(conn, hdr->itt);
>  	if (!cmd)
>  		return 0;
>  
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 7ce3505..e59dec0 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -369,30 +369,6 @@ struct iscsi_cmd *iscsit_find_cmd_from_itt(
>  	return NULL;
>  }
>  
> -struct iscsi_cmd *iscsit_find_cmd_from_itt_or_dump(
> -	struct iscsi_conn *conn,
> -	itt_t init_task_tag,
> -	u32 length)
> -{
> -	struct iscsi_cmd *cmd;
> -
> -	spin_lock_bh(&conn->cmd_lock);
> -	list_for_each_entry(cmd, &conn->conn_cmd_list, i_conn_node) {
> -		if (cmd->init_task_tag == init_task_tag) {
> -			spin_unlock_bh(&conn->cmd_lock);
> -			return cmd;
> -		}
> -	}
> -	spin_unlock_bh(&conn->cmd_lock);
> -
> -	pr_err("Unable to locate ITT: 0x%08x on CID: %hu,"
> -			" dumping payload\n", init_task_tag, conn->cid);
> -	if (length)
> -		iscsit_dump_data_payload(conn, length, 1);
> -
> -	return NULL;
> -}
> -
>  struct iscsi_cmd *iscsit_find_cmd_from_ttt(
>  	struct iscsi_conn *conn,
>  	u32 targ_xfer_tag)
> diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
> index 894d0f8..9614cb9 100644
> --- a/drivers/target/iscsi/iscsi_target_util.h
> +++ b/drivers/target/iscsi/iscsi_target_util.h
> @@ -15,8 +15,6 @@ extern struct iscsi_r2t *iscsit_get_holder_for_r2tsn(struct iscsi_cmd *, u32);
>  int iscsit_sequence_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd, __be32 cmdsn);
>  extern int iscsit_check_unsolicited_dataout(struct iscsi_cmd *, unsigned char *);
>  extern struct iscsi_cmd *iscsit_find_cmd_from_itt(struct iscsi_conn *, itt_t);
> -extern struct iscsi_cmd *iscsit_find_cmd_from_itt_or_dump(struct iscsi_conn *,
> -			itt_t, u32);
>  extern struct iscsi_cmd *iscsit_find_cmd_from_ttt(struct iscsi_conn *, u32);
>  extern int iscsit_find_cmd_for_recovery(struct iscsi_session *, struct iscsi_cmd **,
>  			struct iscsi_conn_recovery **, itt_t);


