Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab3APDze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:55:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:7030 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756483Ab3APDzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:55:32 -0500
X-IronPort-AV: E=Sophos;i="4.84,476,1355068800"; 
   d="scan'208";a="6595715"
Message-ID: <50F624BA.20208@cn.fujitsu.com>
Date: Wed, 16 Jan 2013 11:55:38 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, hutao@cn.fujitsu.com, linux-scsi@vger.kernel.org,
        mst@redhat.com, asias@redhat.com, stefanha@redhat.com,
        nab@linux-iscsi.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] virtio-scsi: reset virtqueue affinity when doing
 cpu hotplug
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com> <50F525E3.1000100@cn.fujitsu.com> <50F52677.80100@cn.fujitsu.com> <871udlztui.fsf@rustcorp.com.au>
In-Reply-To: <871udlztui.fsf@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 11:54:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 11:54:45,
	Serialize complete at 2013/01/16 11:54:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 11:31 AM, Rusty Russell wrote:
> Wanlong Gao <gaowanlong@cn.fujitsu.com> writes:
>> Add hot cpu notifier to reset the request virtqueue affinity
>> when doing cpu hotplug.
> 
> You need to be careful to get_online_cpus() and put_online_cpus() here,
> so CPUs can't go up and down in the middle of operations.
> 
> In particular, get_online_cpus()/put_online_cpus() around calls to
> virtscsi_set_affinity() (except within notifiers).

Yes, I'll take care of this, thank you.

> 
>> +static int virtscsi_cpu_callback(struct notifier_block *nfb,
>> +				 unsigned long action, void *hcpu)
>> +{
>> +	struct virtio_scsi *vscsi = container_of(nfb, struct virtio_scsi, nb);
>> +	switch(action) {
>> +	case CPU_ONLINE:
>> +	case CPU_ONLINE_FROZEN:
>> +	case CPU_DEAD:
>> +	case CPU_DEAD_FROZEN:
>> +		virtscsi_set_affinity(vscsi, true);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +	return NOTIFY_OK;
>> +}
> 
> You probably want to remove affinities *before* the CPU goes down, and
> restore it after the CPU comes up.
> 
> So, how about:
> 
>         switch (action & ~CPU_TASKS_FROZEN) {
>         case CPU_ONLINE:
>         case CPU_DOWN_FAILED:
>                 virtscsi_set_affinity(vscsi, true, -1);
>                 break;
>         case CPU_DOWN_PREPARE:
>                 virtscsi_set_affinity(vscsi, true, (unsigned long)hcpu);
>                 break;
>         }
> 
> The extra argument to virtscsi_set_affinity() is to tell it to ignore a
> cpu which seems online (because it's going down).

OK, thank you very much for teaching this.

> 
>>  static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
>>  			     struct virtqueue *vq)
>>  {
>> @@ -888,6 +909,13 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
>>  	if (err)
>>  		goto virtscsi_init_failed;
>>  
>> +	vscsi->nb.notifier_call = &virtscsi_cpu_callback;
>> +	err = register_hotcpu_notifier(&vscsi->nb);
>> +	if (err) {
>> +		pr_err("virtio_scsi: registering cpu notifier failed\n");
>> +		goto scsi_add_host_failed;
>> +	}
>> +
> 
> You have to clean this up if scsi_add_host() fails, I think.

Yeah, will do, thank you very much. 


Regards,
Wanlong Gao

> 
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

