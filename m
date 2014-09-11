Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaIKIvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:51:21 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:54286 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaIKIvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:51:17 -0400
Message-ID: <5411626B.4040909@linaro.org>
Date: Thu, 11 Sep 2014 10:50:51 +0200
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com
Subject: Re: [RFC v2 6/9] VFIO: Extend external user API
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org> <1409575968-5329-7-git-send-email-eric.auger@linaro.org> <20140911031011.GG2784@lvm>
In-Reply-To: <20140911031011.GG2784@lvm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 05:10 AM, Christoffer Dall wrote:
> On Mon, Sep 01, 2014 at 02:52:45PM +0200, Eric Auger wrote:
>> New functions are added to be called from ARM KVM-VFIO device.
> 
> This commit message seems somewhat random.  This patch doesn't deal with
> anything ARM specific, it introduces some generic functions that allows
> users external to vfio itself to retrieve information about a vfio
> platform device.

Yes you're right.
> 
>>
>> - vfio_device_get_external_user enables to get a vfio device from
>>   its fd
>> - vfio_device_put_external_user puts the vfio device
>> - vfio_external_base_device returns the struct device*,
>>   useful to access the platform_device
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>>
>> v1 -> v2:
>>
>> - vfio_external_get_base_device renamed into vfio_external_base_device
>> - vfio_external_get_type removed
>> ---
>>  drivers/vfio/vfio.c  | 24 ++++++++++++++++++++++++
>>  include/linux/vfio.h |  3 +++
>>  2 files changed, 27 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index 8e84471..282814e 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -1401,6 +1401,30 @@ void vfio_group_put_external_user(struct vfio_group *group)
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_group_put_external_user);
>>  
>> +struct vfio_device *vfio_device_get_external_user(struct file *filep)
>> +{
>> +	struct vfio_device *vdev = filep->private_data;
>> +
>> +	if (filep->f_op != &vfio_device_fops)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	vfio_device_get(vdev);
>> +	return vdev;
>> +}
>> +EXPORT_SYMBOL_GPL(vfio_device_get_external_user);
>> +
>> +void vfio_device_put_external_user(struct vfio_device *vdev)
>> +{
>> +	vfio_device_put(vdev);
>> +}
>> +EXPORT_SYMBOL_GPL(vfio_device_put_external_user);
>> +
>> +struct device *vfio_external_base_device(struct vfio_device *vdev)
>> +{
>> +	return vdev->dev;
>> +}
>> +EXPORT_SYMBOL_GPL(vfio_external_base_device);
>> +
>>  int vfio_external_user_iommu_id(struct vfio_group *group)
>>  {
>>  	return iommu_group_id(group->iommu_group);
>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index ffe04ed..bd4b6cb 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -99,6 +99,9 @@ extern void vfio_group_put_external_user(struct vfio_group *group);
>>  extern int vfio_external_user_iommu_id(struct vfio_group *group);
>>  extern long vfio_external_check_extension(struct vfio_group *group,
>>  					  unsigned long arg);
>> +extern struct vfio_device *vfio_device_get_external_user(struct file *filep);
>> +extern void vfio_device_put_external_user(struct vfio_device *vdev);
>> +extern struct device *vfio_external_base_device(struct vfio_device *vdev);
>>  
>>  struct pci_dev;
>>  #ifdef CONFIG_EEH
>> -- 
>> 1.9.1
>>
> Looks good to me,
> -Christoffer
> 

