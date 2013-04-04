Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab3DDJvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:51:20 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:41558 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759411Ab3DDJvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:51:17 -0400
Message-ID: <515D4D0E.40005@mellanox.com>
Date: Thu, 4 Apr 2013 12:51:10 +0300
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>,
        Alexander Nezhinsky <alexandern@mellanox.com>
Subject: Re: [RFC-v3 9/9] iser-target: Add iSCSI Extensions for RDMA (iSER)
 target driver
References: <1365060256-21506-1-git-send-email-nab@linux-iscsi.org> <1365060256-21506-10-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1365060256-21506-10-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 10:24, Nicholas A. Bellinger wrote:
> +static int
> +isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
> +{
> +	struct isert_cmd *isert_cmd = container_of(cmd,
> +					struct isert_cmd, iscsi_cmd);
> +	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
> +	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
> +	struct iscsi_scsi_rsp *hdr = (struct iscsi_scsi_rsp *)
> +				&isert_cmd->tx_desc.iscsi_header;
> +
> +	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
> +	iscsit_build_rsp_pdu(cmd, conn, true, hdr);
> +	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
> +	/*
> +	 * Attach SENSE DATA payload to iSCSI Response PDU
> +	 */
> +	if (cmd->se_cmd.sense_buffer &&
> +	    ((cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
> +	    (cmd->se_cmd.se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
> +		struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
> +		struct ib_sge *tx_dsg = &isert_cmd->tx_desc.tx_sg[1];
> +		u32 padding, sense_len;
> +
> +		put_unaligned_be16(cmd->se_cmd.scsi_sense_length,
> +				   cmd->sense_buffer);
> +		cmd->se_cmd.scsi_sense_length += sizeof(__be16);
> +
> +		padding = -(cmd->se_cmd.scsi_sense_length) & 3;
> +		hton24(hdr->dlength, (u32)cmd->se_cmd.scsi_sense_length);
> +		sense_len = cmd->se_cmd.scsi_sense_length + padding;
> +
> +		isert_cmd->sense_buf_dma = ib_dma_map_single(ib_dev,
> +				(void *)cmd->sense_buffer, sense_len,
> +				DMA_TO_DEVICE);
> +
> +		isert_cmd->sense_buf_len = sense_len;
> +		ib_dma_sync_single_for_cpu(ib_dev, isert_cmd->sense_buf_dma,
> +					   sense_len, DMA_TO_DEVICE);
> +		ib_dma_sync_single_for_device(ib_dev, isert_cmd->sense_buf_dma,
> +					      sense_len, DMA_TO_DEVICE);
> +

you just called dma_map_single, and not going to touch the buffer before 
posting it to the wire,
there's no point to sync it for the cpu and for the device, remove these 
calls.


> +		tx_dsg->addr	= isert_cmd->sense_buf_dma;
> +		tx_dsg->length	= sense_len;
> +		tx_dsg->lkey	= isert_conn->conn_mr->lkey;
> +		isert_cmd->tx_desc.num_sge = 2;
> +	}
> +
> +	isert_init_send_wr(isert_cmd, send_wr);
> +
> +	pr_debug("Posting SCSI Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
> +
> +	return isert_post_response(isert_conn, isert_cmd);
> +}

