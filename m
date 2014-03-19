Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbaCSA7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:59:42 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50389 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013AbaCSA7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:59:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140318143407.0df4457f@thinkpad>
References: <1394890540-2435-1-git-send-email-zhouzhouyi@gmail.com>
	<20140317142851.50e5f533@thinkpad>
	<CAABZP2zrLqTRu4sTbYSQ58G1SHGR_YhdGC7365aVmyq6q1n_dg@mail.gmail.com>
	<20140318143407.0df4457f@thinkpad>
Date: Wed, 19 Mar 2014 08:59:39 +0800
Message-ID: <CAABZP2xBE4ekbgX=uv4FTGmNMcx5RMnxLdqZdgeqyyDzx0kOJw@mail.gmail.com>
Subject: Re: [PATCH] s390: correct misuses of module_put in appldata_generic_handler.
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, joe@perches.com, gang.chen@asianux.com,
        linux390@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delicate design!  thanks for replying, sorry for the trouble

On Tue, Mar 18, 2014 at 9:34 PM, Gerald Schaefer
<gerald.schaefer@de.ibm.com> wrote:
> On Tue, 18 Mar 2014 09:24:55 +0800
> Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
>
>> Thanks Gerald for reviewing and sorry for not elaborated it in the e-mail.
>>
>> Firstly, I think you can't call module_put after fail try_module_get
>
> There is another try_module_get() in this function before that, so I need
> to call module_put() once if the second try_module_get() fails.
>
> The first try_module_get() is only needed within the function, while the
> second one is needed to prevent a module from being unloaded while its
> callback is registered, so that reference is kept as long as the module
> is active.
>
>>
>> Secondly, there exists duplicate module_put on the program path (the last
>> one is before return 0)
>
> There is one module_put() for every try_module_get(). If "1" is written
> to the sysctl, the function exits with one "missing" module_put(), which
> is held to protect the callback. When "0" is written, this reference
> is returned again with an "extra" module_put().
>
>>
>> On Mon, Mar 17, 2014 at 9:28 PM, Gerald Schaefer
>> <gerald.schaefer@de.ibm.com> wrote:
>> > On Sat, 15 Mar 2014 21:35:40 +0800
>> > Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
>> >
>> >> correct misuses of module_put in  appldata_generic_handler
>> >
>> > Sorry, I don't see any misuse, could you elaborate?
>> >
>> >>
>> >> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
>> >> ---
>> >>  arch/s390/appldata/appldata_base.c | 3 ---
>> >>  1 file changed, 3 deletions(-)
>> >>
>> >> diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
>> >> index 47c8630..683e0282 100644
>> >> --- a/arch/s390/appldata/appldata_base.c
>> >> +++ b/arch/s390/appldata/appldata_base.c
>> >> @@ -343,7 +343,6 @@ appldata_generic_handler(struct ctl_table *ctl, int write,
>> >>               // protect work queue callback
>> >>               if (!try_module_get(ops->owner)) {
>> >>                       mutex_unlock(&appldata_ops_mutex);
>> >> -                     module_put(ops->owner);
>> >>                       return -ENODEV;
>> >>               }
>> >>               ops->callback(ops->data);       // init record
>> >> @@ -354,7 +353,6 @@ appldata_generic_handler(struct ctl_table *ctl, int write,
>> >>               if (rc != 0) {
>> >>                       pr_err("Starting the data collection for %s "
>> >>                              "failed with rc=%d\n", ops->name, rc);
>> >> -                     module_put(ops->owner);
>> >>               } else
>> >>                       ops->active = 1;
>> >>       } else if ((buf[0] == '0') && (ops->active == 1)) {
>> >> @@ -365,7 +363,6 @@ appldata_generic_handler(struct ctl_table *ctl, int write,
>> >>               if (rc != 0)
>> >>                       pr_err("Stopping the data collection for %s "
>> >>                              "failed with rc=%d\n", ops->name, rc);
>> >> -             module_put(ops->owner);
>> >>       }
>> >>       mutex_unlock(&appldata_ops_mutex);
>> >>  out:
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-s390" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
