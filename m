Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab3CTHcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 03:32:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38706 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab3CTHb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 03:31:57 -0400
X-IronPort-AV: E=Sophos;i="4.84,877,1355068800"; 
   d="scan'208";a="6908591"
Message-ID: <51496636.8040000@cn.fujitsu.com>
Date: Wed, 20 Mar 2013 15:33:10 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Asias He <asias@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        rusty@rustcorp.com.au, mst@redhat.com, JBottomley@parallels.com,
        venkateshs@google.com, pbonzini@redhat.com
Subject: Re: [PATCH V6 5/5] virtio-scsi: reset virtqueue affinity when doing
 cpu hotplug
References: <1363762884-11000-1-git-send-email-gaowanlong@cn.fujitsu.com> <1363762884-11000-6-git-send-email-gaowanlong@cn.fujitsu.com> <20130320072425.GA23182@hj.localdomain>
In-Reply-To: <20130320072425.GA23182@hj.localdomain>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 15:30:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 15:30:24,
	Serialize complete at 2013/03/20 15:30:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 03:24 PM, Asias He wrote:
> On Wed, Mar 20, 2013 at 03:01:24PM +0800, Wanlong Gao wrote:
>> Add hot cpu notifier to reset the request virtqueue affinity
>> when doing cpu hotplug.
>>
>> Cc: linux-scsi@vger.kernel.org
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
>> Reviewed-by: Asias He <asias@redhat.com>
>> ---
>>  drivers/scsi/virtio_scsi.c | 29 +++++++++++++++++++++++++++++
>>  1 file changed, 29 insertions(+)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 13d7672..0ad9017 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -110,6 +110,9 @@ struct virtio_scsi {
>>  	/* if the affinity hint is set for virtqueues */
>>  	bool affinity_hint_set;
>>  
>> +	/* CPU hotplug notifier */
>> +	struct notifier_block nb;
>> +
>>  	struct virtio_scsi_vq ctrl_vq;
>>  	struct virtio_scsi_vq event_vq;
>>  	struct virtio_scsi_vq req_vqs[];
>> @@ -762,6 +765,23 @@ static void virtscsi_set_affinity(struct virtio_scsi *vscsi, bool affinity)
>>  	put_online_cpus();
>>  }
>>  
>> +static int virtscsi_cpu_callback(struct notifier_block *nfb,
>> +				 unsigned long action, void *hcpu)
>> +{
>> +	struct virtio_scsi *vscsi = container_of(nfb, struct virtio_scsi, nb);
>> +	switch(action) {
>> +	case CPU_ONLINE:
>> +	case CPU_ONLINE_FROZEN:
>> +	case CPU_DEAD:
>> +	case CPU_DEAD_FROZEN:
>> +		__virtscsi_set_affinity(vscsi, true);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +	return NOTIFY_OK;
>> +}
>> +
>>  static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
>>  			     struct virtqueue *vq)
>>  {
>> @@ -884,6 +904,13 @@ static int virtscsi_probe(struct virtio_device *vdev)
>>  	if (err)
>>  		goto virtscsi_init_failed;
>>  
>> +	vscsi->nb.notifier_call = &virtscsi_cpu_callback;
>> +	err = register_hotcpu_notifier(&vscsi->nb);
>> +	if (err) {
>> +		pr_err("registering cpu notifier failed\n");
>> +		goto scsi_add_host_failed;
>> +	}
>> +
>>  	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
>>  	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
>>  	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
>> @@ -921,6 +948,8 @@ static void virtscsi_remove(struct virtio_device *vdev)
>>  
>>  	scsi_remove_host(shost);
>>  
>> +	unregister_hotcpu_notifier(&vscsi->nb);
>> +
>>  	virtscsi_remove_vqs(vdev);
>>  	scsi_host_put(shost);
>>  }
>> -- 
>> 1.8.2.rc2
>>
> 
> This one does not apply on top of virtio-next + patch 1-4 in this series.

Oops, it's my fault. There may be something wrong here. But you can use "3-way merge"
to apply them, I'll take care next time.


Thanks,
Wanlong Gao

> 

