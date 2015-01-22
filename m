Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbbAVRFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:05:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40808 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbAVRFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:05:32 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v2] ARM: qcom: Fix SCM interface for big-endian kernels
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1421868075-20471-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 22 Jan 2015 11:05:28 -0600
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <EF8384DD-D1D4-40F8-BCD7-D6516E923120@codeaurora.org>
References: <1421868075-20471-1-git-send-email-sboyd@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 21, 2015, at 1:21 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> The secure environment only runs in little-endian mode, so any
> buffers shared with the secure environment should have their
> contents converted to little-endian. We also mark such elements
> with __le32 to allow sparse to catch such problems.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> Changes since v1:
> * Rebased onto Kumar's qcom/soc branch
> 
> drivers/soc/qcom/scm-boot.c |  8 ++++----
> drivers/soc/qcom/scm.c      | 30 ++++++++++++++++--------------
> 2 files changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/soc/qcom/scm-boot.c b/drivers/soc/qcom/scm-boot.c
> index 1822b13bbc10..af16fcc8d5cb 100644
> --- a/drivers/soc/qcom/scm-boot.c
> +++ b/drivers/soc/qcom/scm-boot.c
> @@ -27,12 +27,12 @@
> int scm_set_boot_addr(u32 addr, int flags)
> {
> 	struct {
> -		unsigned int flags;
> -		phys_addr_t  addr;
> +		__le32 flags;
> +		__le32 addr;

How does this work?  How can we go from phys_addr_t back to __le32 on LPAE or 64-bit systems?

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
> index 2e98d80e2387..3e724b8af485 100644
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
> a Linux Foundation Collaborative Project
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

