Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996AbaLPTcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:32:48 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63149 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaLPTcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:32:46 -0500
MIME-Version: 1.0
In-Reply-To: <54907676.4050108@cogentembedded.com>
References: <1418746353-3481-1-git-send-email-octavian.purdila@intel.com>
	<1418746353-3481-2-git-send-email-octavian.purdila@intel.com>
	<54907676.4050108@cogentembedded.com>
Date: Tue, 16 Dec 2014 21:32:44 +0200
Message-ID: <CAE1zotL5W=PpKjrcCV_Q_nBdpm+cakn7NOqqjEwx3WEcYduacw@mail.gmail.com>
Subject: Re: [PATCH 1/4] ACPICA: take ACPI_MTX_INTERPRETER in acpi_unload_table_id
From: Octavian Purdila <octavian.purdila@intel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 8:14 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
> On 12/16/2014 07:12 PM, Octavian Purdila wrote:
>
>> acpi_tb_delete_namespace_by_owner expects ACPI_MTX_INTERPRETER to be
>> taken. This fixes the following issue:
>
>
>> ACPI Error: Mutex [0x0] is not acquired, cannot release
>> (20141107/utmutex-322)
>> Call Trace:
>>    [<ffffffff81b0bd28>] dump_stack+0x4f/0x7b
>>    [<ffffffff81546bfc>] acpi_ut_release_mutex+0x47/0x67
>>    [<ffffffff81542cf1>] acpi_tb_delete_namespace_by_owner+0x57/0x8d
>>    [<ffffffff81543ef1>] acpi_unload_table_id+0x3a/0x5e
>
>
>> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
>> ---
>>   drivers/acpi/acpica/tbxface.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>
>
>> diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
>> index 6482b0d..9520ae1 100644
>> --- a/drivers/acpi/acpica/tbxface.c
>> +++ b/drivers/acpi/acpica/tbxface.c
>> @@ -281,6 +281,11 @@ acpi_status acpi_unload_table_id(acpi_owner_id id)
>>
>>         ACPI_FUNCTION_TRACE(acpi_unload_table_id);
>>
>> +       status = acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);
>> +       if (ACPI_FAILURE(status)) {
>> +               return_ACPI_STATUS(status);
>> +       }
>
>
>    {} not needed here. Please run your patches thru scripts/checkpatch.pl,
> it should complain in this case.
>

I always run checkpatch. It does not complain.

>> +
>>         /* Find table in the global table list */
>>         for (i = 0; i < acpi_gbl_root_table_list.current_table_count; ++i)
>> {
>>                 if (id != acpi_gbl_root_table_list.tables[i].owner_id) {
>> @@ -297,6 +302,8 @@ acpi_status acpi_unload_table_id(acpi_owner_id id)
>>                 acpi_tb_set_table_loaded_flag(i, FALSE);
>>                 break;
>>         }
>> +
>> +       (void)acpi_ut_release_mutex(ACPI_MTX_INTERPRETER);
>
>
>    Cast to *void*  not necessary either.
>

AFAICS ACPICA has a slight different coding style than the rest of the
kernel and I kept using it in these patches. Rafael, please let me
know if I am wrong.
