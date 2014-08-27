Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbaH0K1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:27:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24820 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaH0K1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:27:40 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-26-53fdb2991300
Message-id: <53FDB297.7070400@samsung.com>
Date: Wed, 27 Aug 2014 12:27:35 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Joonyoung Shim <jy0922.shim@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 06/15] drm/exynos/ipp: free partially allocated resources
 on error
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
 <1408693946-15456-7-git-send-email-a.hajda@samsung.com>
 <53FC1460.5090000@samsung.com>
In-reply-to: <53FC1460.5090000@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsVy+t/xK7ozN/0NNvjTx2Jx5et7NotJ9yew
	WLy4d5HF4mzTG3aLy7vmsFnMOL+PyWLtkbvsFjMmv2Rz4PC4332cyaNvyypGj8+b5AKYo7hs
	UlJzMstSi/TtErgyTszczlTQL1VxYMVu9gbGfyJdjJwcEgImEjve9LBD2GISF+6tZ+ti5OIQ
	EljKKPF91T4WCOcTo0Tn8m8sIFW8AloS2+8/BrNZBFQl/kx5ygpiswloSvzdfJMNxBYVCJN4
	9usgE0S9oMSPyffA6kUEfCW2/H/NCDKUWWABk8S3Bx1gRcICERJ/Tx6H2jaPUWLWi0dACQ4O
	TgFtiUXbUkFMZgE9ifsXtUDKmQXkJTavecs8gVFgFpIVsxCqZiGpWsDIvIpRNLU0uaA4KT3X
	SK84Mbe4NC9dLzk/dxMjJLS/7mBceszqEKMAB6MSD6/C6T/BQqyJZcWVuYcYJTiYlUR42Wf9
	DRbiTUmsrEotyo8vKs1JLT7EyMTBKdXAeOr86qmTQz8XKXhJ+y/hitozZSb30V8brrxS2lLd
	seMWr9YBgbtXJjQp3F21kOezwNob3xlcJ/a7PNryUCTdcdbEUzzv4182rbSX/pqmNlNjHs/N
	FrZVfruv9rbtfJ2Vv3nXzSUlbFJpDkrHHXa0Jurs/u/JsPMDK/utDwFnJeal7V/OpVHFJK3E
	UpyRaKjFXFScCABBX1I8SwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 07:00 AM, Joonyoung Shim wrote:
> Hi Andrzej,
>
> On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
>> In case of allocation errors some already allocated buffers
>> were not freed. The patch fixes it.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> ---
>>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 68 ++++++++++++++++-----------------
>>  1 file changed, 33 insertions(+), 35 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>> index 060a198..728f3b9 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>> @@ -599,6 +599,37 @@ static int ipp_set_mem_node(struct exynos_drm_ippdrv *ippdrv,
>>  	return ret;
>>  }
>>  
>> +static int ipp_put_mem_node(struct drm_device *drm_dev,
>> +		struct drm_exynos_ipp_cmd_node *c_node,
>> +		struct drm_exynos_ipp_mem_node *m_node)
>> +{
>> +	int i;
>> +
>> +	DRM_DEBUG_KMS("node[0x%x]\n", (int)m_node);
>> +
>> +	if (!m_node) {
>> +		DRM_ERROR("invalid dequeue node.\n");
>> +		return -EFAULT;
>> +	}
>> +
>> +	DRM_DEBUG_KMS("ops_id[%d]\n", m_node->ops_id);
>> +
>> +	/* put gem buffer */
>> +	for_each_ipp_planar(i) {
>> +		unsigned long handle = m_node->buf_info.handles[i];
>> +		if (handle)
>> +			exynos_drm_gem_put_dma_addr(drm_dev, handle,
>> +							c_node->filp);
>> +	}
>> +
>> +	/* conditionally remove from queue */
>> +	if (m_node->list.next)
> How about do INIT_LIST_HEAD for list in ipp_get_mem_node()?

I am not sure if it is better. For sure it adds unnecessary
initialization sequence.
Maybe adding list_is_initialized inline function to list.h would be the
best solution.

Regards
Andrzej

>
>> +		list_del(&m_node->list);
>> +	kfree(m_node);
>> +
>> +	return 0;
>> +}
>> +
>>  static struct drm_exynos_ipp_mem_node
>>  		*ipp_get_mem_node(struct drm_device *drm_dev,
>>  		struct drm_file *file,
>> @@ -634,7 +665,8 @@ static struct drm_exynos_ipp_mem_node
>>  					qbuf->handle[i], file);
>>  			if (IS_ERR(addr)) {
>>  				DRM_ERROR("failed to get addr.\n");
>> -				goto err_clear;
>> +				ipp_put_mem_node(drm_dev, c_node, m_node);
>> +				return ERR_PTR(-EFAULT);
>>  			}
>>  
>>  			buf_info->handles[i] = qbuf->handle[i];
>> @@ -649,40 +681,6 @@ static struct drm_exynos_ipp_mem_node
>>  	mutex_unlock(&c_node->mem_lock);
>>  
>>  	return m_node;
>> -
>> -err_clear:
>> -	kfree(m_node);
>> -	return ERR_PTR(-EFAULT);
>> -}
>> -
>> -static int ipp_put_mem_node(struct drm_device *drm_dev,
>> -		struct drm_exynos_ipp_cmd_node *c_node,
>> -		struct drm_exynos_ipp_mem_node *m_node)
>> -{
>> -	int i;
>> -
>> -	DRM_DEBUG_KMS("node[0x%x]\n", (int)m_node);
>> -
>> -	if (!m_node) {
>> -		DRM_ERROR("invalid dequeue node.\n");
>> -		return -EFAULT;
>> -	}
>> -
>> -	DRM_DEBUG_KMS("ops_id[%d]\n", m_node->ops_id);
>> -
>> -	/* put gem buffer */
>> -	for_each_ipp_planar(i) {
>> -		unsigned long handle = m_node->buf_info.handles[i];
>> -		if (handle)
>> -			exynos_drm_gem_put_dma_addr(drm_dev, handle,
>> -							c_node->filp);
>> -	}
>> -
>> -	/* delete list in queue */
>> -	list_del(&m_node->list);
>> -	kfree(m_node);
>> -
>> -	return 0;
>>  }
>>  
>>  static void ipp_free_event(struct drm_pending_event *event)
>>
>

