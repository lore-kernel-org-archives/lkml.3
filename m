Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3AYJQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:16:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:13965 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab3AYJQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:16:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,537,1355068800"; 
   d="scan'208";a="6646040"
Message-ID: <51024D5E.6000409@cn.fujitsu.com>
Date: Fri, 25 Jan 2013 17:16:14 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V7 1/3] virtio-net: fix the set affinity bug when CPU
 IDs are not consecutive
References: <1359102981-3401-1-git-send-email-gaowanlong@cn.fujitsu.com> <510249C6.2000105@redhat.com> <51024AC7.9030109@cn.fujitsu.com> <51024C3A.6080200@redhat.com>
In-Reply-To: <51024C3A.6080200@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/25 17:15:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/25 17:15:23,
	Serialize complete at 2013/01/25 17:15:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>>  
>>>> -	for (i = 0; i < vi->max_queue_pairs; i++) {
>>>> -		int cpu = set ? i : -1;
>>>> -		virtqueue_set_affinity(vi->rq[i].vq, cpu);
>>>> -		virtqueue_set_affinity(vi->sq[i].vq, cpu);
>>>> -	}
>>>> +	if (set) {
>>>> +		i = 0;
>>>> +		for_each_online_cpu(cpu) {
>>>> +			virtqueue_set_affinity(vi->rq[i].vq, cpu);
>>>> +			virtqueue_set_affinity(vi->sq[i].vq, cpu);
>>>> +			*per_cpu_ptr(vi->vq_index, cpu) = i;
>>>> +			i++;
>>>> +		}
>>>>  
>>>> -	if (set)
>>>>  		vi->affinity_hint_set = true;
>>>> -	else
>>>> +	} else {
>>>> +		for(i = 0; i < vi->max_queue_pairs; i++) {
>>>> +			virtqueue_set_affinity(vi->rq[i].vq, -1);
>>>> +			virtqueue_set_affinity(vi->sq[i].vq, -1);
>>>> +		}
>>>> +
>>>> +		i = 0;
>>>> +		for_each_online_cpu(cpu)
>>>> +			*per_cpu_ptr(vi->vq_index, cpu) =
>>>> +				++i % vi->curr_queue_pairs;
>>>> +
>>>>  		vi->affinity_hint_set = false;
>>>> +	}
>>>>  }
>>> Sorry, looks like the issue of v6 still exists, we need set per-cpu
>>> index unconditionally here (and also in 2/3), the cpus != queues check
>>> may bypass this setting.
>> This fixed in 2/3, when cpus != queues, it will go into virtnet_clean_affinity(in 2/3),
>> then vq index is set in virtnet_clean_affinity. Am I missing something?
> 
> Ah, so 2/3 looks fine. I suggest to fix this in 1/3 since it's not good
> to introduce a bug in patch 1 and fix it in patch 2, and this can also
> confuse the bisect.
> 

Make sense, will move the fix from 2/3 to 1/3.

Thanks,
Wanlong Gao

