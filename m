Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbbAVJbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:31:38 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42771 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbbAVJbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:31:32 -0500
Date: Thu, 22 Jan 2015 01:31:29 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, bleung@google.com,
        dan.carpenter@oracle.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] input: cyapa: fix sparse warning issue of incorrect
 type in assiggment
Message-ID: <20150122093129.GA7133@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudl@cypress.com>, dmitry.torokhov@gmail.com,
	rydberg@euromail.se, bleung@google.com, dan.carpenter@oracle.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1421909406-1240-1-git-send-email-dudl@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421909406-1240-1-git-send-email-dudl@cypress.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

Mis-spelled 'assiggment' in Subject line.

On Thu, Jan 22, 2015 at 02:50:05PM +0800, Dudley Du wrote:
> Fixes the sparse warning issue of the incorrect type in assignment which
> found by the kbuild test robot.
> 
I wasn't able to reproduce the sparse warning.  Was it for a specific
architecture?  Perhaps include a link to the email sent by the kbuild
test robot.

[...]
>  struct gen5_bl_metadata_row_params {
>  	__le16 size;
> -	__le16 maximun_size;
> +	__le16 maximum_size;
I don't think sparse cares about variable names.
Be sure to note these changes in your log.

>  	__le32 app_start;
>  	__le16 app_len;
>  	__le16 app_crc;
> @@ -1192,67 +1192,69 @@ static int cyapa_gen5_bl_enter(struct cyapa *cyapa)
>  static int cyapa_gen5_check_fw(struct cyapa *cyapa, const struct firmware *fw)
>  {
>  	struct device *dev = &cyapa->client->dev;
> -	struct gen5_bl_metadata_row_params metadata;
> -	struct cyapa_tsg_bin_image *image;
> -	int flash_records_count;
> -	u16 app_crc = 0;
> -	u16 app_integrity_crc = 0;
> -	u16 row_num;
> -	u8 *data;
> +	const struct cyapa_tsg_bin_image *image = (const void *)fw->data;
> +	const struct cyapa_tsg_bin_image_data_record *app_integrity;
> +	const struct gen5_bl_metadata_row_params *metadata;
> +	size_t flash_records_count;
> +	u32 fw_app_start, fw_upgrade_start;
> +	u16 fw_app_len, fw_upgrade_len;
> +	u16 app_crc;
> +	u16 app_integrity_crc;
>  	int record_index;
>  	int i;
>  
> -	image = (struct cyapa_tsg_bin_image *)fw->data;
>  	flash_records_count = (fw->size -
>  			sizeof(struct cyapa_tsg_bin_image_head)) /
>  			sizeof(struct cyapa_tsg_bin_image_data_record);
>  
> -	/* APP_INTEGRITY row is always the last row block,
> -	 * and the row id must be 0x01ff */
> -	row_num = get_unaligned_be16(
> -			&image->records[flash_records_count - 1].row_number);
> -	if (image->records[flash_records_count - 1].flash_array_id != 0x00 &&
> -			row_num != 0x01ff) {
> +	/*
> +	 * APP_INTEGRITY row is always the last row block,
> +	 * and the row id must be 0x01ff.
> +	 */
> +	app_integrity = &image->records[flash_records_count - 1];
> +
> +	if (app_integrity->flash_array_id != 0x00 ||
> +	    get_unaligned_be16(&app_integrity->row_number) != 0x01ff) {
I could be wrong but it looks there are a lot of changes un-related to
the sparse warning.  I am not opposed to this per se but they should be
noted in the log message.

[...]

-- 
- Jeremiah Mahler
