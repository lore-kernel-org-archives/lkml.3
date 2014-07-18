Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935091AbaGRUCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:02:01 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53533 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaGRUCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:02:00 -0400
Message-ID: <53C97D34.5040707@gmail.com>
Date: Fri, 18 Jul 2014 22:01:56 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Vladimir Davydov <vdavydov@parallels.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69 kmem_cache_create+0x1a9/0x330()
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com> <20140718132104.GK27940@esperanza> <20140718141747.GA23272@lst.de>
In-Reply-To: <20140718141747.GA23272@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.07.2014 16:17, Christoph Hellwig wrote:
> On Fri, Jul 18, 2014 at 05:21:04PM +0400, Vladimir Davydov wrote:
>> Slab warns, because the name of the cache being created contains spaces.
>> The "bad" cache is created by scsi_get_host_cmd_pool. Its name
>> (pool->cmd_name) is initialized by scsi_alloc_host_cmd_pool as follows:
>>
>> 	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->name);
>>
>> So, if hostt->name contains spaces, the cache name will also contain
>> spaces and we'll get the warning. And hostt->name can contain spaces,
>> e.g. virtscsi_host_template_single.name="Virtio SCSI HBA".
>
> Or might not even be present.  I'll send a patch to replace it with
> ->proc_name, which must not contain spaces and is generally shorter
> as well.
>

Is this what you thought?
@@ -148,20 +148,20 @@
  	struct kmem_cache	*cmd_slab;
  	struct kmem_cache	*sense_slab;
  	unsigned int		users;
-	char			*cmd_name;
+	char			*proc_name;
  	char			*sense_name;
  	unsigned int		slab_flags;
  	gfp_t			gfp_mask;
  };
  
  static struct scsi_host_cmd_pool scsi_cmd_pool = {
-	.cmd_name	= "scsi_cmd_cache",
+	.proc_name	= "scsi_cmd_cache",
  	.sense_name	= "scsi_sense_cache",
  	.slab_flags	= SLAB_HWCACHE_ALIGN,
  };
  
  static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
-	.cmd_name	= "scsi_cmd_cache(DMA)",
+	.proc_name	= "scsi_cmd_cache(DMA)",
  	.sense_name	= "scsi_sense_cache(DMA)",
  	.slab_flags	= SLAB_HWCACHE_ALIGN|SLAB_CACHE_DMA,
  	.gfp_mask	= __GFP_DMA,
@@ -354,7 +354,7 @@
  scsi_free_host_cmd_pool(struct scsi_host_cmd_pool *pool)
  {
  	kfree(pool->sense_name);
-	kfree(pool->cmd_name);
+	kfree(pool->proc_name);
  	kfree(pool);
  }
  
@@ -368,9 +368,9 @@
  	if (!pool)
  		return NULL;
  
-	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->name);
+	pool->proc_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->name);
  	pool->sense_name = kasprintf(GFP_KERNEL, "%s_sense", hostt->name);
-	if (!pool->cmd_name || !pool->sense_name) {
+	if (!pool->proc_name || !pool->sense_name) {
  		scsi_free_host_cmd_pool(pool);
  		return NULL;
  	}
@@ -403,7 +403,7 @@
  	}
  
  	if (!pool->users) {
-		pool->cmd_slab = kmem_cache_create(pool->cmd_name, cmd_size, 0,
+		pool->cmd_slab = kmem_cache_create(pool->proc_name, cmd_size, 0,
  						   pool->slab_flags, NULL);
  		if (!pool->cmd_slab)
  			goto out_free_pool;


however ain't workin.


poma


