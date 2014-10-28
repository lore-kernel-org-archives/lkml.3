Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbaJ1IRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:17:05 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52872 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbaJ1IQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:16:59 -0400
MIME-Version: 1.0
In-Reply-To: <20141028051935.GF60814@vmdeb7>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
	<1414005163-3461-5-git-send-email-fransklaver@gmail.com>
	<20141028051935.GF60814@vmdeb7>
Date: Tue, 28 Oct 2014 09:16:57 +0100
Message-ID: <CAH6sp9N3_XZPrZvw25XrkyvCm5HccMmkgFiPrJgCnBqVhjLYjw@mail.gmail.com>
Subject: Re: [PATCH 4/8] eeepc-laptop: pull out eeepc_destroy_rfkill
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 6:19 AM, Darren Hart <dvhart@infradead.org> wrote:
> On Wed, Oct 22, 2014 at 09:12:39PM +0200, Frans Klaver wrote:
>> In eeepc_rfkill_exit, we implement the same code four times. Pull out a
>> function that cleans up an rfkill object to get rid of the duplication.
>>
>> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
>> ---
>>  drivers/platform/x86/eeepc-laptop.c | 34 ++++++++++++++--------------------
>>  1 file changed, 14 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
>> index e92ea41..73e8d39 100644
>> --- a/drivers/platform/x86/eeepc-laptop.c
>> +++ b/drivers/platform/x86/eeepc-laptop.c
>> @@ -823,35 +823,29 @@ static char EEEPC_RFKILL_NODE_1[] = "\\_SB.PCI0.P0P5";
>>  static char EEEPC_RFKILL_NODE_2[] = "\\_SB.PCI0.P0P6";
>>  static char EEEPC_RFKILL_NODE_3[] = "\\_SB.PCI0.P0P7";
>>
>> +static inline void eeepc_destroy_rfkill(struct rfkill **rfkill)
>> +{
>> +     if (!*rfkill)
>> +             return;
>> +     rfkill_unregister(*rfkill);
>> +     rfkill_destroy(*rfkill);
>> +     *rfkill = NULL;
>> +}
>
> In this case the savings is 6 lines at the cost of some legibility as double
> pointers are arguably harder to read, and definitely easier to screw up ;-)
>
> I appreciate the goal, but I'm not convinced it is worth it.

Fair enough. If anything the following would be slightly less complicated:

#define eeepc_destroy_rfkill(rfkill) \
do { \
        if (rfkill) { \
                 rfkill_unregister(rfkill); \
                 rfkill_destroy(rfkill); \
                 rkfill = NULL; \
        } \
} while (0);

I don't think any new eeepc's are being produced, so this code is
unlikely to change anyway. Let's leave it as is.

Thanks,
Frans
