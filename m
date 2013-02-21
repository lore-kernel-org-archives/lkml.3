Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3BUP4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:56:23 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:46098 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab3BUP4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:56:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130220104627.GF16388@WorkStation.localnet>
References: <1360496352-29482-1-git-send-email-sjur.brandeland@stericsson.com>
	<1360496352-29482-10-git-send-email-sjur.brandeland@stericsson.com>
	<20130220104627.GF16388@WorkStation.localnet>
Date: Thu, 21 Feb 2013 16:56:08 +0100
Message-ID: <CANHm3Pi-cXKFX-RWiw4suVNyAN29hre9swQdhUCNhikB15YtAA@mail.gmail.com>
Subject: Re: [PATCH 9/9] remoteproc: Always perserve resource table data
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbr@gmail.com>
To: Ido Yariv <ido@wizery.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ido,

On Wed, Feb 20, 2013 at 11:46 AM, Ido Yariv <ido@wizery.com> wrote:
> Hi Sjur,
>
> On Sun, Feb 10, 2013 at 12:39:12PM +0100, sjur.brandeland@stericsson.com wrote:
>> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>>
>> Copy resource table from first to second firmware loading.
>> After firmware is loaded to memory, update the vdevs resource
>> pointer to the resource table kept in device memory.
>>
>> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
>> ---
>>  drivers/remoteproc/remoteproc_core.c |   61 +++++++++++++++++++++++++++------
>>  include/linux/remoteproc.h           |    3 ++
>>  2 files changed, 53 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
>> index 14f40eb..13dc7b4 100644
>> --- a/drivers/remoteproc/remoteproc_core.c
>> +++ b/drivers/remoteproc/remoteproc_core.c
>> @@ -694,17 +694,16 @@ static rproc_handle_resource_t rproc_handle_notifyid_rsc[RSC_LAST] = {
>>
>>  /* handle firmware resource entries before booting the remote processor */
>>  static int
>> -rproc_handle_resource(struct rproc *rproc, struct resource_table *table,
>> -                             int len,
>> -                             rproc_handle_resource_t handlers[RSC_LAST])
>> +rproc_handle_resource(struct rproc *rproc, int len,
>> +                   rproc_handle_resource_t handlers[RSC_LAST])
>>  {
>>       struct device *dev = &rproc->dev;
>>       rproc_handle_resource_t handler;
>>       int ret = 0, i;
>>
>> -     for (i = 0; i < table->num; i++) {
>> -             int offset = table->offset[i];
>> -             struct fw_rsc_hdr *hdr = (void *)table + offset;
>> +     for (i = 0; i < rproc->rsc->num; i++) {
>> +             int offset = rproc->rsc->offset[i];
>> +             struct fw_rsc_hdr *hdr = (void *)rproc->rsc + offset;
>>               int avail = len - offset - sizeof(*hdr);
>>               void *rsc = (void *)hdr + sizeof(*hdr);
>>
>> @@ -783,9 +782,13 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
>>  {
>>       struct device *dev = &rproc->dev;
>>       const char *name = rproc->firmware;
>> -     struct resource_table *table;
>> +     struct rproc_vdev *rvdev;
>> +     struct resource_table *table, *devmem_rsc, *tmp;
>>       int ret, tablesz;
>>
>> +     if (!rproc->rsc)
>> +             return -ENOMEM;
>> +
>>       ret = rproc_fw_sanity_check(rproc, fw);
>>       if (ret)
>>               return ret;
>> @@ -811,8 +814,17 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
>>               goto clean_up;
>>       }
>>
>> +     /* Verify that resource table in loaded fw is unchanged */
>> +     if (rproc->rsc_csum != ip_compute_csum(table, tablesz)) {
>> +             dev_err(dev, "resource checksum failed, fw changed?\n");
>> +             ret = -EINVAL;
>> +             goto clean_up;
>> +     }
>> +
>> +
>
> Remove empty line?

Ok.

>
>>       /* handle fw resources which are required to boot rproc */
>> -     ret = rproc_handle_resource(rproc, table, tablesz, rproc_handle_rsc);
>> +     ret = rproc_handle_resource(rproc, tablesz,
>> +                                     rproc_handle_rsc);
>
> This can fit in one line now :)

Ok,

>
>>       if (ret) {
>>               dev_err(dev, "Failed to process resources: %d\n", ret);
>>               goto clean_up;
>> @@ -825,6 +837,26 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
>>               goto clean_up;
>>       }
>>
>> +     /* Get the resource table address in device memory */
>> +     devmem_rsc = rproc_get_rsctab_addr(rproc, fw);
>> +
>> +     /* Copy the updated resource table to device memory */
>> +     memcpy(devmem_rsc, rproc->rsc, tablesz);
>> +
>> +     /* Free the copy of the resource table */
>> +     tmp = rproc->rsc;
>> +     rproc->rsc = devmem_rsc;
>
> This is also set a few lines below, and we can probably do without tmp
> altogether.
>
>> +     kfree(tmp);
>
> If rproc_fw_boot is called more than once, kfree will try to free memory that
> was not kmalloced, leading to a panic.
>
> Instead of freeing the pointer here, it should be kept until rproc is
> released, reverting rproc->rsc to it every time shutdown is called. It
> can be freed when rproc is finally released.

Agree. I will free the copy in rproc_trigger_recovery and in rproc_del,
and set rproc->rsc = rproc->rsc_copy at shutdown.

>
>> +
>> +     /* Update the vdev rsc address */
>> +     list_for_each_entry(rvdev, &rproc->rvdevs, node) {
>> +             int offset = (void *)rvdev->rsc - (void *)tmp;
>> +             rvdev->rsc = (void *)devmem_rsc + offset;
>> +     }
>
> I think it might be nicer and less error prone to hold the offsets to
> the resources instead of pointers. This will require modifying
> "remoteproc: Support virtio config space" accordingly, but will save the
> trouble of updating pointers later on (both here, and on shutdown as
> suggested above).

Ok, I've changed this as well. We now work with offsets from the start
of the resource table. I also updated the typedef rproc_handle_resource_t
to include the resource offset as well. In this way we're consistently handling
resource offsets.

>
>> +
>> +     /* Other virtio drivers will see the rsc table in device memory */
>> +     rproc->rsc = devmem_rsc;
>> +
>>       /* power up the remote processor */
>>       ret = rproc->ops->start(rproc);
>>       if (ret) {
>> @@ -866,14 +898,21 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
>>       if (!table)
>>               goto out;
>>
>> -     rproc->max_notifyid = 0;
>> +     rproc->rsc_csum = ip_compute_csum(table, tablesz);
>
> Doesn't matter much and any checksum would do, but given that this is not an IP
> packet perhaps use something more generic (crc32 or similar)?
> In any case, an appropriate dependency should to remoteproc's Kconfig.

OK, I'll change to crc32 and update Kconfig.

>
>>
>>       /* count the numbe of notify-ids */
>> -     ret = rproc_handle_resource(rproc, table, tablesz,
>> +     rproc->max_notifyid = 0;
>> +     rproc->rsc = table;
>
> Instead of temporarily setting rproc->rsc here, why not just set it up before
> figuring out the maximum notification id?

Yes, will do.

>
>> +     ret = rproc_handle_resource(rproc, tablesz,
>>                                               rproc_handle_notifyid_rsc);
>>
>> +     /* Copy resource table containing vdev config info */
>> +     rproc->rsc = kmalloc(tablesz, GFP_KERNEL);
>> +     if (rproc->rsc)
>> +             memcpy(rproc->rsc, table, tablesz);
>> +
>
> If the kmalloc above returned NULL, we should probably bail out here.

Agree.

>
>>       /* look for virtio devices and register them */
>> -     ret = rproc_handle_resource(rproc, table, tablesz,
>> +     ret = rproc_handle_resource(rproc, tablesz,
>>                                               rproc_handle_vdev_rsc);
>
> This can fit in one line now

Yes,

I have reworked this patch according to your review comments. I had to
reshuffle the order of patches in order to change from using pointers to
offset to resource entries.
The other comments you have on the other patches seems easy to fix.
(Please take a second look on the overflow checks though).
I will send out an updated patch-set addressing your review comments
very soon. I would appreciate a somewhat faster response this time though...

Thanks,
Sjur
