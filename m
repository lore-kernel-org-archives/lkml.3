Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaIWQsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:48:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37221 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbaIWQsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:48:03 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] ARM: qcom: Fix SCM interface for big-endian kernels
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1411425393-5537-1-git-send-email-sboyd@codeaurora.org>
Date: Tue, 23 Sep 2014 11:47:58 -0500
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F694D53D-F606-4B35-AED9-9B3927E4E9F1@codeaurora.org>
References: <1411425393-5537-1-git-send-email-sboyd@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 22, 2014, at 5:36 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> The secure environment only runs in little-endian mode, so any
> buffers shared with the secure environment should have their
> contents converted to little-endian. We also mark such elements
> with __le32 to allow sparse to catch such problems.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> drivers/soc/qcom/scm-boot.c |  8 ++++----
> drivers/soc/qcom/scm.c      | 34 ++++++++++++++++++----------------
> 2 files changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/soc/qcom/scm-boot.c b/drivers/soc/qcom/scm-boot.c
> index 60ff7b482141..3e4d77b371c6 100644
> --- a/drivers/soc/qcom/scm-boot.c
> +++ b/drivers/soc/qcom/scm-boot.c
> @@ -27,12 +27,12 @@
> int scm_set_boot_addr(phys_addr_t addr, int flags)
> {
> 	struct {
> -		unsigned int flags;
> -		phys_addr_t  addr;
> +		__le32 flags;
> +		__le32 addr;

Hmm, was phys_addr_t wrong here before?  I ask because don’t we support LPAE on some systems?

> 	} cmd;
> 
> -	cmd.addr = addr;
> -	cmd.flags = flags;
> +	cmd.addr = cpu_to_le32(addr);
> +	cmd.flags = cpu_to_le32(flags);
> 	return scm_call(SCM_SVC_BOOT, SCM_BOOT_ADDR,
> 			&cmd, sizeof(cmd), NULL, 0);
> }
> diff --git a/drivers/soc/qcom/scm.c b/drivers/soc/qcom/scm.c
> index be1e2beec796..feeb4e4bb22d 100644
> --- a/drivers/soc/qcom/scm.c
> +++ b/drivers/soc/qcom/scm.c
> @@ -62,11 +62,11 @@ static DEFINE_MUTEX(scm_lock);
>  * to access the buffers in a safe manner.
>  */
> struct scm_command {
> -	u32	len;
> -	u32	buf_offset;
> -	u32	resp_hdr_offset;
> -	u32	id;
> -	u32	buf[0];
> +	__le32 len;
> +	__le32 buf_offset;
> +	__le32 resp_hdr_offset;
> +	__le32 id;
> +	__le32 buf[0];
> };
> 
> /**
> @@ -76,9 +76,9 @@ struct scm_command {
>  * @is_complete: indicates if the command has finished processing
>  */
> struct scm_response {
> -	u32	len;
> -	u32	buf_offset;
> -	u32	is_complete;
> +	__le32 len;
> +	__le32 buf_offset;
> +	__le32 is_complete;
> };
> 
> /**
> @@ -96,12 +96,14 @@ static struct scm_command *alloc_scm_command(size_t cmd_size, size_t resp_size)
> 	struct scm_command *cmd;
> 	size_t len = sizeof(*cmd) + sizeof(struct scm_response) + cmd_size +
> 		resp_size;
> +	u32 offset;
> 
> 	cmd = kzalloc(PAGE_ALIGN(len), GFP_KERNEL);
> 	if (cmd) {
> -		cmd->len = len;
> -		cmd->buf_offset = offsetof(struct scm_command, buf);
> -		cmd->resp_hdr_offset = cmd->buf_offset + cmd_size;
> +		cmd->len = cpu_to_le32(len);
> +		offset = offsetof(struct scm_command, buf);
> +		cmd->buf_offset = cpu_to_le32(offset);
> +		cmd->resp_hdr_offset = cpu_to_le32(offset + cmd_size);
> 	}
> 	return cmd;
> }
> @@ -126,7 +128,7 @@ static inline void free_scm_command(struct scm_command *cmd)
> static inline struct scm_response *scm_command_to_response(
> 		const struct scm_command *cmd)
> {
> -	return (void *)cmd + cmd->resp_hdr_offset;
> +	return (void *)cmd + le32_to_cpu(cmd->resp_hdr_offset);
> }
> 
> /**
> @@ -148,7 +150,7 @@ static inline void *scm_get_command_buffer(const struct scm_command *cmd)
>  */
> static inline void *scm_get_response_buffer(const struct scm_response *rsp)
> {
> -	return (void *)rsp + rsp->buf_offset;
> +	return (void *)rsp + le32_to_cpu(rsp->buf_offset);
> }
> 
> static int scm_remap_error(int err)
> @@ -201,8 +203,8 @@ static int __scm_call(const struct scm_command *cmd)
> 	 * Flush the command buffer so that the secure world sees
> 	 * the correct data.
> 	 */
> -	__cpuc_flush_dcache_area((void *)cmd, cmd->len);
> -	outer_flush_range(cmd_addr, cmd_addr + cmd->len);
> +	__cpuc_flush_dcache_area((void *)cmd, le32_to_cpu(cmd->len));
> +	outer_flush_range(cmd_addr, cmd_addr + le32_to_cpu(cmd->len));
> 
> 	ret = smc(cmd_addr);
> 	if (ret < 0)
> @@ -260,7 +262,7 @@ int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
> 	if (!cmd)
> 		return -ENOMEM;
> 
> -	cmd->id = (svc_id << 10) | cmd_id;
> +	cmd->id = cpu_to_le32((svc_id << 10) | cmd_id);
> 	if (cmd_buf)
> 		memcpy(scm_get_command_buffer(cmd), cmd_buf, cmd_len);
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

