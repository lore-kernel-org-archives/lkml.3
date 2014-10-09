Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaJIFFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 01:05:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42537 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaJIFE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 01:04:56 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5436173A.1050002@jp.fujitsu.com>
Date: Thu, 9 Oct 2014 14:03:54 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
CC: <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH] driver/base/node: remove unnecessary kfree of node struct
 from unregister_one_node
References: <542E750B.4000508@jp.fujitsu.com> <54360ABF.9030302@huawei.com>
In-Reply-To: <54360ABF.9030302@huawei.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/09 13:10), Xishi Qiu wrote:
> On 2014/10/3 18:06, Yasuaki Ishimatsu wrote:
> 
>> Commit 92d585ef067d ("numa: fix NULL pointer access and memory
>> leak in unregister_one_node()") added kfree() of node struct in
>> unregister_one_node(). But node struct is freed by node_device_release()
>> which is called in  unregister_node(). So by adding the kfree(),
> 
> Hi,
> 
> Is this path?
> unregister_node()
>    device_unregister()
>      device_del()
>        bus_remove_device()
>          device_release_driver()
>            __device_release_driver()
>              devres_release_all()
>                release_nodes()
>                  dr->node.release(dev, dr->data);
>                    then which function is be called?

node_device_release is called as follows:

unregister_one_node()
-> unregister_node()
  -> device_unregister()
    -> put_device()
      -> kobject_put()
        -> kref_put()
          -> kref_sub()
            -> kobject_release()
              -> kobject_cleanup()
                -> device_release()
                  -> node_device_release()

Thanks,
Yasuaki Ishimatsu

> 
> Thanks,
> Xishi Qiu
> 
>> node struct is freed two times.
>>
>> While hot removing memory, the commit leads the following BUG_ON():
>>
>>    kernel BUG at mm/slub.c:3346!
>>    invalid opcode: 0000 [#1] SMP
>>    [...]
>>    Call Trace:
>>     [...] unregister_one_node
>>     [...] try_offline_node
>>     [...] remove_memory
>>     [...] acpi_memory_device_remove
>>     [...] acpi_bus_trim
>>     [...] acpi_bus_trim
>>     [...] acpi_device_hotplug
>>     [...] acpi_hotplug_work_fn
>>     [...] process_one_work
>>     [...] worker_thread
>>     [...] ? rescuer_thread
>>     [...] kthread
>>     [...] ? kthread_create_on_node
>>     [...] ret_from_fork
>>     [...] ? kthread_create_on_node
>>
>> This patch removes unnecessary kfree() from unregister_one_node().
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Cc: Xishi Qiu <qiuxishi@huawei.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: stable@vger.kernel.org # v3.16+
>> Fixes: 92d585ef067d "numa: fix NULL pointer access and memory leak in unregister_one_node()"
>> ---
>>   drivers/base/node.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index c6d3ae0..d51c49c 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -603,7 +603,6 @@ void unregister_one_node(int nid)
>>   		return;
>>
>>   	unregister_node(node_devices[nid]);
>> -	kfree(node_devices[nid]);
>>   	node_devices[nid] = NULL;
>>   }
>>
> 
> 
> 


