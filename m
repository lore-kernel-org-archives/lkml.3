Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaCLJtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:49:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:62393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbaCLJtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:49:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,636,1389772800"; 
   d="scan'208";a="498288847"
Date: Wed, 12 Mar 2014 17:48:53 +0800
From: Liu ShuoX <shuox.liu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 2/2] pstore: correct the max_dump_cnt clearing of ramoops
Message-ID: <20140312094853.GA3067@lskakaxi-intel>
References: <20140311061519.GA11552@lskakaxi-intel>
 <20140311061742.GB11552@lskakaxi-intel>
 <CAGXu5jLkAdy7ctHRf8Yr36gvOBeJNuph5r7M9HNfH4DxTXpF0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5jLkAdy7ctHRf8Yr36gvOBeJNuph5r7M9HNfH4DxTXpF0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11.Mar'14 at 13:37:23 -0700, Kees Cook wrote:
>On Mon, Mar 10, 2014 at 11:17 PM, Liu ShuoX <shuox.liu@intel.com> wrote:
>> From: Liu ShuoX <shuox.liu@intel.com>
>>
>> In case that ramoops_init_przs failed, max_dump_cnt won't be reset to
>> zero in error handle path.
>>
>> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
>> ---
>>  fs/pstore/ram.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
>> index 6f96d8c..522e530 100644
>> --- a/fs/pstore/ram.c
>> +++ b/fs/pstore/ram.c
>> @@ -326,6 +326,7 @@ static void ramoops_free_przs(struct ramoops_context
>> *cxt)
>>         for (i = 0; !IS_ERR_OR_NULL(cxt->przs[i]); i++)
>>                 persistent_ram_free(cxt->przs[i]);
>>         kfree(cxt->przs);
>> +       cxt->max_dump_cnt = 0;
>>  }
>>   static int ramoops_init_przs(struct device *dev, struct ramoops_context
>> *cxt,
>> @@ -350,7 +351,7 @@ static int ramoops_init_przs(struct device *dev, struct
>> ramoops_context *cxt,
>>                              GFP_KERNEL);
>>         if (!cxt->przs) {
>>                 dev_err(dev, "failed to initialize a prz array for
>> dumps\n");
>> -               return -ENOMEM;
>> +               goto fail_prz;
>
>This will have no effect. If cxt->przs == NULL, ramoops_free_przs will
>immediately exit too, not hitting your max_dump_cnt = 0 change.
>Perhaps move the =0 in that function to the top before the check and
>return?
Yes, you are right. Below has the latest patch which move the =0 to the
top of that function, just as you mentioned. Thanks.
>
>>         }
>>         for (i = 0; i < cxt->max_dump_cnt; i++) {
>> @@ -508,7 +509,6 @@ fail_buf:
>>         kfree(cxt->pstore.buf);
>>  fail_clear:
>>         cxt->pstore.bufsize = 0;
>> -       cxt->max_dump_cnt = 0;
>>  fail_cnt:
>>         kfree(cxt->fprz);
>>  fail_init_fprz:
>> --
>> 1.8.3.2
>>
>
>Otherwise,  yes, once fixed, this clean-up looks good -- it keeps the
>variable initialization and cleanup all in ramoops_init_przs() which
>is how it should be.
>
>Thanks!
>
>-Kees
-----

From: Liu ShuoX <shuox.liu@intel.com>

In case that ramoops_init_przs failed, max_dump_cnt won't be reset to
zero in error handle path.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
  fs/pstore/ram.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 6f96d8c..3b57443 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -320,6 +320,7 @@ static void ramoops_free_przs(struct ramoops_context *cxt)
  {
  	int i;
  
+	cxt->max_dump_cnt = 0;
  	if (!cxt->przs)
  		return;
  
@@ -350,7 +351,7 @@ static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
  			     GFP_KERNEL);
  	if (!cxt->przs) {
  		dev_err(dev, "failed to initialize a prz array for dumps\n");
-		return -ENOMEM;
+		goto fail_prz;
  	}
  
  	for (i = 0; i < cxt->max_dump_cnt; i++) {
@@ -508,7 +509,6 @@ fail_buf:
  	kfree(cxt->pstore.buf);
  fail_clear:
  	cxt->pstore.bufsize = 0;
-	cxt->max_dump_cnt = 0;
  fail_cnt:
  	kfree(cxt->fprz);
  fail_init_fprz:
-- 
1.8.3.2

