Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab3HVCu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:50:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50693 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3HVCu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:50:28 -0400
Message-ID: <52157C6E.6080406@oracle.com>
Date: Thu, 22 Aug 2013 10:50:22 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH v2] dm ioctl: allow change device target type
 to error
References: <5214CC25.1070307@oracle.com> <alpine.LRH.2.02.1308211041180.10797@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1308211041180.10797@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas, thanks for you suggestions, I create new patch, can you please help
review?

Subject: dm: add map_rq define for error

commit a5664da "dm ioctl: make bio or request based device type immutable"
prevented "dmsetup wape_table" change the target type to "error" for there
is not map_rq for error target type.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
---
 drivers/md/dm-target.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 37ba5db..b690910 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -131,12 +131,19 @@ static int io_err_map(struct dm_target *tt, struct bio *bio)
 	return -EIO;
 }
 
+static int io_err_map_rq(struct dm_target *ti, struct request *clone,
+			 union map_info *map_context)
+{
+	return -EIO;
+}
+
 static struct target_type error_target = {
 	.name = "error",
 	.version = {1, 1, 0},
 	.ctr  = io_err_ctr,
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
+	.map_rq = io_err_map_rq,
 };
 
 int __init dm_target_init(void)
-- 
1.8.3.1

On 08/21/13 22:48, Mikulas Patocka wrote:
> 
> 
> On Wed, 21 Aug 2013, Joe Jin wrote:
> 
>> commit a5664da "dm ioctl: make bio or request based device type immutable"
>> prevented "dmsetup wape_table" change the target type to "error".
> 
> That commit a5664da is there for a reason (it is not possible to change 
> bio-based device to request-based and vice versa) and I don't really see 
> how this patch is supposed to work.
> 
> If there are bios that are in flight and that already passed through 
> blk_queue_bio, and you change the device from request-based to bio-based, 
> what are you going to do with them? - The patch doesn't do anything about 
> it.
> 
> A better approach would be to create a new request-based target "error-rq" 
> and change the multipath target to "error-rq" target. That way, you don't 
> have to change device type from request based to bio based.
> 
> Mikulas
> 
>> -v2: setup md->queue even target type is "error".
>>
>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
>> ---
>>  drivers/md/dm-ioctl.c |  4 ++++
>>  drivers/md/dm-table.c | 12 ++++++++++++
>>  drivers/md/dm.h       |  1 +
>>  3 files changed, 17 insertions(+)
>>
>> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
>> index f1b7586..2a9b63d 100644
>> --- a/drivers/md/dm-ioctl.c
>> +++ b/drivers/md/dm-ioctl.c
>> @@ -1280,6 +1280,9 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
>>  		goto out;
>>  	}
>>  
>> +	if (dm_is_error_target(t))
>> +		goto error_target;
>> +
>>  	/* Protect md->type and md->queue against concurrent table loads. */
>>  	dm_lock_md_type(md);
>>  	if (dm_get_md_type(md) == DM_TYPE_NONE)
>> @@ -1293,6 +1296,7 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
>>  		goto out;
>>  	}
>>  
>> +error_target:
>>  	/* setup md->queue to reflect md's type (may block) */
>>  	r = dm_setup_md_queue(md);
>>  	if (r) {
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index f221812..27be46a 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -184,6 +184,18 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
>>  	return 0;
>>  }
>>  
>> +bool dm_is_error_target(struct dm_table *t)
>> +{
>> +	unsigned i;
>> +
>> +	for (i = 0; i < t->num_targets; i++) {
>> +		struct dm_target *tgt = t->targets + i;
>> +		if (strcmp(tgt->type->name, "error") == 0)
>> +			return true;
>> +	}
>> +	return false;
>> +}
>> +
>>  int dm_table_create(struct dm_table **result, fmode_t mode,
>>  		    unsigned num_targets, struct mapped_device *md)
>>  {
>> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
>> index 45b97da..c7bceeb 100644
>> --- a/drivers/md/dm.h
>> +++ b/drivers/md/dm.h
>> @@ -69,6 +69,7 @@ unsigned dm_table_get_type(struct dm_table *t);
>>  struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
>>  bool dm_table_request_based(struct dm_table *t);
>>  bool dm_table_supports_discards(struct dm_table *t);
>> +bool dm_is_error_target(struct dm_table *t);
>>  int dm_table_alloc_md_mempools(struct dm_table *t);
>>  void dm_table_free_md_mempools(struct dm_table *t);
>>  struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
>> -- 
>> 1.8.3.1
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
