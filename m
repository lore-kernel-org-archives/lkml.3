Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3DWBrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 21:47:37 -0400
Received: from intranet.asianux.com ([58.214.24.6]:19490 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3DWBrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 21:47:36 -0400
X-Spam-Score: -100.8
Message-ID: <5175E80A.7030908@asianux.com>
Date: Tue, 23 Apr 2013 09:46:50 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/audit_tree.c: tree will memory leak when failure
 occurs for audit_trim_trees()
References: <517110BA.5070806@asianux.com> <20130422160409.471f6208099a972d26c29fb9@linux-foundation.org>
In-Reply-To: <20130422160409.471f6208099a972d26c29fb9@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月23日 07:04, Andrew Morton wrote:
> On Fri, 19 Apr 2013 17:39:06 +0800 Chen Gang <gang.chen@asianux.com> wrote:
> 
>>
>> in audit_trim_trees(), has called get_tree() before failure occurs,
>> so need also call put_tree after go to skip_it:
>>
>> ...
>>
>> --- a/kernel/audit_tree.c
>> +++ b/kernel/audit_tree.c
>> @@ -617,10 +617,10 @@ void audit_trim_trees(void)
>>  		}
>>  		spin_unlock(&hash_lock);
>>  		trim_marked(tree);
>> -		put_tree(tree);
>>  		drop_collected_mounts(root_mnt);
>>  skip_it:
>>  		mutex_lock(&audit_filter_mutex);
>> +		put_tree(tree);
>>  	}
>>  	list_del(&cursor);
>>  	mutex_unlock(&audit_filter_mutex);
> 
> That looks right to me.
> 
> I think we can micro-optimise the code by performing the put_tree()
> before taking the mutex, to slightly reduce mutex hold times?
> 

  ok, thanks.

> --- a/kernel/audit_tree.c~kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix
> +++ a/kernel/audit_tree.c
> @@ -619,8 +619,8 @@ void audit_trim_trees(void)
>  		trim_marked(tree);
>  		drop_collected_mounts(root_mnt);
>  skip_it:
> -		mutex_lock(&audit_filter_mutex);
>  		put_tree(tree);
> +		mutex_lock(&audit_filter_mutex);
>  	}
>  	list_del(&cursor);
>  	mutex_unlock(&audit_filter_mutex);
> _
> 
> 
> 
> 


-- 
Chen Gang

Asianux Corporation
