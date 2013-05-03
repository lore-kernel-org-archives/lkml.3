Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763674Ab3ECVEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:04:55 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:43101 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763435Ab3ECVEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:04:52 -0400
MIME-Version: 1.0
In-Reply-To: <1365799962-13543-8-git-send-email-nab@linux-iscsi.org>
References: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
	<1365799962-13543-8-git-send-email-nab@linux-iscsi.org>
Date: Fri, 3 May 2013 23:04:50 +0200
X-Google-Sender-Auth: to8aSmYVpBAg2fzj1ZM7lLw9JiY
Message-ID: <CAMuHMdWVpF9G2v5oSYL642mpWdQCMGBhSQYa=Zw0s9DyoNJLjQ@mail.gmail.com>
Subject: Re: [RFC-v4 7/9] iscsi-target: Refactor TX queue logic + export
 response PDU creation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>,
        Alexander Nezhinsky <alexandern@mellanox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicholas,

On Fri, Apr 12, 2013 at 10:52 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c

>  static int iscsit_send_reject(
>         struct iscsi_cmd *cmd,
>         struct iscsi_conn *conn)
> @@ -3505,18 +3548,9 @@ static int iscsit_send_reject(
>         struct iscsi_reject *hdr;
>         struct kvec *iov;
>
> -       hdr                     = (struct iscsi_reject *) cmd->pdu;

Woops, and now hdr is no longer initialized:

drivers/target/iscsi/iscsi_target.c: In function ‘iscsit_send_reject’:
drivers/target/iscsi/iscsi_target.c:3577: warning: ‘hdr’ is used
uninitialized in this function

> -       hdr->opcode             = ISCSI_OP_REJECT;
> -       hdr->flags              |= ISCSI_FLAG_CMD_FINAL;
> -       hton24(hdr->dlength, ISCSI_HDR_LEN);
> -       hdr->ffffffff           = cpu_to_be32(0xffffffff);
> -       cmd->stat_sn            = conn->stat_sn++;
> -       hdr->statsn             = cpu_to_be32(cmd->stat_sn);
> -       hdr->exp_cmdsn  = cpu_to_be32(conn->sess->exp_cmd_sn);
> -       hdr->max_cmdsn  = cpu_to_be32(conn->sess->max_cmd_sn);
> +       iscsit_build_reject(cmd, conn, (struct iscsi_reject *)&cmd->pdu[0]);

Hence it will crash later:

                iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
                                (unsigned char *)hdr, ISCSI_HDR_LEN,
                                0, NULL, (u8 *)header_digest);

and

        pr_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
                " CID: %hu\n", ntohl(hdr->statsn), hdr->reason, conn->cid);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
