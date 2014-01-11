Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbaAKAZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 19:25:51 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:36971 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaAKAZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 19:25:49 -0500
X-AuditID: cbfec37d-b7ff46d000005528-70-52d08f8c0e81
Message-id: <52D08F89.10109@samsung.com>
Date: Fri, 10 Jan 2014 17:25:45 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Joerg Roedel <joro@8bytes.org>
Cc: akpm@linux-foundation.org, alexander.h.duyck@intel.com,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH v2] dma-debug: enhance dma_debug_device_change() to check
 for mapping errors
References: <1384376168-2148-1-git-send-email-shuah.kh@samsung.com>
 <20131230141511.GC2799@8bytes.org> <52C700BC.1010200@samsung.com>
 <20140107142625.GC2742@8bytes.org> <52CC1691.9040603@samsung.com>
 <20140107151200.GA29041@8bytes.org> <52CC37F1.6080704@samsung.com>
In-reply-to: <52CC37F1.6080704@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.13]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t9hX92e/gtBBvcniVjMWb+GzeLkst/M
	Fp2zN7BbXN41h83i608HB1aPJwfnMXnsnHWX3WPxnpdMHidm/Gbx+LxJLoA1issmJTUnsyy1
	SN8ugStj3+0HzAVzRSue3z/J3MD4ka+LkZNDQsBEorvjNzOELSZx4d56ti5GLg4hgWWMErdP
	bGOBcHqZJL7+2MAO4WxilHjRN4sRpIVXQEPiWvtlJhCbRUBVYtu7B+wgNpuAusTn1zvAbCEB
	OYmmJavBVogKREi8OjuRBaJXUOLH5HtgtoiAksT1z62sIAuYBQ4yStxbcI0VJCEskCQxbf58
	JojNE5gkrr57zgaS4BTQlrjfNwesiFnAWmLlpG2MELa8xOY1b5khNitL/Ll8igniOUWJib8v
	ME9gFJmFZPksJO2zkLQvYGRexShWWpxcUJyUnlpholecmFtcmpeul5yfu4kREjm1Oxjvf7U5
	xCjAwajEw+vBeyFIiDWxrLgy9xCjBAezkghvjC9QiDclsbIqtSg/vqg0J7X4ECMTB6dUA+MS
	ofLU+bcYV334fPqahMyVuUJPswxM+38u9D7Vdap6upma/pkdkWsS+83PLvHP3cBjNmfKVo7I
	qi2rv+8IW6/CoFj+iVnDIV2q7kZfzoeprofDpp8t1Fqc6srHviFvlyvLvq41s3nUspqm3142
	6dj57ZHWK5ss2P5+vCa2WO8Qt+YUmXtXPZ4qsRRnJBpqMRcVJwIAzz/yBXoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 10:22 AM, Shuah Khan wrote:
> On 01/07/2014 08:12 AM, Joerg Roedel wrote:
>> On Tue, Jan 07, 2014 at 08:00:33AM -0700, Shuah Khan wrote:
>>> This patch and a follow-on cocinelli warning fix patch are in
>>> linux-next. Would you like me to send a patch relative to the change
>>> in linux-next or cut a new patch against the latest Linus's git. I
>>> can go either way. We just have to remember to drop those two
>>> patches from linux-next.
>>
>> Please do a patch against linus.git and drop the two patches from
>> linux-next. Over which tree did they go into linux-next anyway?
>>
>>
>
> ok. It went through mm tree.
>

I have a separate routine now for scanning for entries with map error 
flag set and I also have a new err_printk() call to print the entry from 
dma_debug_device_change() right after device_dma_allocations() check and 
corresponding err_printk(). Snippet of the diff below. Only one warning 
gets printed. Looking at err_printk(): if (!show_all_errors && 
show_num_errors > 0) conditional, it appears that is the way it is 
supposed to work, unless I am missing something

One way to not miss the second warning is to just generate just a 
pr_err() for the mapping error instead of err_printk(). Leaked entries 
is a bigger problem that should really be shown and the same entry might 
not have the map error flag set. Thoughts?

  static int dma_debug_device_change(struct notifier_block *nb, unsigned 
long action, void *data)
  {
         struct device *dev = data;
@@ -758,6 +784,18 @@ static int dma_debug_device_change(struct 
notifier_block *nb, unsigned long acti
                                 "[mapped with %s] [mapped as %s]\n",
                         count, entry->dev_addr, entry->size,
                         dir2name[entry->direction], 
type2name[entry->type]);
+
+               count = device_dma_map_errors(dev, &entry);
+               if (count == 0)
+                       break;
+               err_printk(dev, entry,
+                               "DMA-API: device driver failed to check 
map err"
+                               ": [count=%d]\n"
+                               "Details of an entry with map error flag 
set: "
+                               "[device address=0x%016llx] [size=%llu 
bytes] "
+                               "[mapped with %s] [mapped as %s]\n",
+                       count, entry->dev_addr, entry->size,
+                       dir2name[entry->direction], type2name[entry->type]);
                 break;


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
