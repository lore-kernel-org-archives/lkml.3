Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3FDO2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:28:16 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36253 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab3FDO16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:27:58 -0400
Message-ID: <51ADF965.3000905@gmail.com>
Date: Tue, 04 Jun 2013 22:27:49 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/8] zram: avoid invalid memory access in zram_exit()
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com> <1370274140-26420-3-git-send-email-jiang.liu@huawei.com> <20130604090309.GB28551@blaptop>
In-Reply-To: <20130604090309.GB28551@blaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04 Jun 2013 05:03:09 PM CST, Minchan Kim wrote:
> On Mon, Jun 03, 2013 at 11:42:14PM +0800, Jiang Liu wrote:
>> Memory for zram->disk object may have already been freed after returning
>> from destroy_device(zram), then it's unsafe for zram_reset_device(zram)
>> to access zram->disk again.
>>
>> Fix it by holding an extra reference to zram->disk before calling
>> destroy_device(zram).
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> ---
>>  drivers/staging/zram/zram_drv.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index e34e3fe..ee6b67d 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -727,8 +727,10 @@ static void __exit zram_exit(void)
>>  	for (i = 0; i < num_devices; i++) {
>>  		zram = &zram_devices[i];
>>
>> +		get_disk(zram->disk);
>>  		destroy_device(zram);
>>  		zram_reset_device(zram);
>> +		put_disk(zram->disk);
>
> Can't we simple reverse calling order of above two functions?
>
>         zram_reset_device(zram);
>         destroy_device(zram);
>
Hi Minchan,
     We can't solve this bug by changing the order of the two functions.
If we change the order, it will cause corner cases to zram sysfs 
handler,
which will be hard to solve too.
Regards!
Gerry

