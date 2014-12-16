Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaLPSOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:14:21 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:61083 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaLPSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:14:19 -0500
Message-ID: <54907676.4050108@cogentembedded.com>
Date: Tue, 16 Dec 2014 21:14:14 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Octavian Purdila <octavian.purdila@intel.com>, linus.walleij@linaro.org,
        lee.jones@linaro.org, rjw@rjwysocki.net
CC: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, heikki.krogerus@intel.com,
        mika.westerberg@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/4] ACPICA: take ACPI_MTX_INTERPRETER in acpi_unload_table_id
References: <1418746353-3481-1-git-send-email-octavian.purdila@intel.com> <1418746353-3481-2-git-send-email-octavian.purdila@intel.com>
In-Reply-To: <1418746353-3481-2-git-send-email-octavian.purdila@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/16/2014 07:12 PM, Octavian Purdila wrote:

> acpi_tb_delete_namespace_by_owner expects ACPI_MTX_INTERPRETER to be
> taken. This fixes the following issue:

> ACPI Error: Mutex [0x0] is not acquired, cannot release (20141107/utmutex-322)
> Call Trace:
>    [<ffffffff81b0bd28>] dump_stack+0x4f/0x7b
>    [<ffffffff81546bfc>] acpi_ut_release_mutex+0x47/0x67
>    [<ffffffff81542cf1>] acpi_tb_delete_namespace_by_owner+0x57/0x8d
>    [<ffffffff81543ef1>] acpi_unload_table_id+0x3a/0x5e

> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>   drivers/acpi/acpica/tbxface.c | 7 +++++++
>   1 file changed, 7 insertions(+)

> diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
> index 6482b0d..9520ae1 100644
> --- a/drivers/acpi/acpica/tbxface.c
> +++ b/drivers/acpi/acpica/tbxface.c
> @@ -281,6 +281,11 @@ acpi_status acpi_unload_table_id(acpi_owner_id id)
>
>   	ACPI_FUNCTION_TRACE(acpi_unload_table_id);
>
> +	status = acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);
> +	if (ACPI_FAILURE(status)) {
> +		return_ACPI_STATUS(status);
> +	}

    {} not needed here. Please run your patches thru scripts/checkpatch.pl, it 
should complain in this case.

> +
>   	/* Find table in the global table list */
>   	for (i = 0; i < acpi_gbl_root_table_list.current_table_count; ++i) {
>   		if (id != acpi_gbl_root_table_list.tables[i].owner_id) {
> @@ -297,6 +302,8 @@ acpi_status acpi_unload_table_id(acpi_owner_id id)
>   		acpi_tb_set_table_loaded_flag(i, FALSE);
>   		break;
>   	}
> +
> +	(void)acpi_ut_release_mutex(ACPI_MTX_INTERPRETER);

    Cast to *void*  not necessary either.

[...]

WBR, Sergei

