Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3GDEZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:25:22 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52395 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3GDEZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:25:21 -0400
Message-ID: <51D4F92B.8020200@hitachi.com>
Date: Thu, 04 Jul 2013 13:25:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
References: <51D16E1D.5040904@hitachi.com>  <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com>  <1372799087.22688.58.camel@gandalf.local.home>  <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com>  <51D38F8D.3010708@hitachi.com> <20130703172029.GA14309@redhat.com>  <20130703175420.GA25668@redhat.com>  <1372874547.22688.111.camel@gandalf.local.home>  <20130703191748.GA2884@redhat.com> <1372885365.22688.126.camel@gandalf.local.home>
In-Reply-To: <1372885365.22688.126.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/04 6:02), Steven Rostedt wrote:
> On Wed, 2013-07-03 at 21:17 +0200, Oleg Nesterov wrote:
> 
>> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
>> index 4888cb3..c23d41e 100644
>> --- a/fs/debugfs/inode.c
>> +++ b/fs/debugfs/inode.c
>> @@ -475,6 +475,7 @@ static int __debugfs_remove(struct dentry *dentry, struct dentry *parent)
>>  				kfree(dentry->d_inode->i_private);
>>  				/* fall through */
>>  			default:
>> +				dentry->d_inode->i_private = NULL;
>>  				simple_unlink(parent->d_inode, dentry);
>>  				break;
>>  			}
> 
> Ah, I see what you are saying. If the file is being opened just as it is
> being deleted, it can up the dentry refcount and prevent it from
> actually being deleted at that point. :-p

Yeah, that's actually what I'd like to point out.,,

> 
> There's a slight race that we can get to the open call when the dentry
> was deleted. But can it? Seems that there would be other places that
> have issues as I would think it would be common to do something like:
> 
> 	data = kmalloc(size, GFP_KERNEL);
> 	dentry = debugfs_create_file("file", 0644, parent, data, &ops);
> 
> [...]
> 
> 	debugfs_remove(dentry);
> 	kfree(data);
> 
> Any thing like this would have issues if the open referenced the data.

I'm not so sure about vfs layer, but yes, I think that pattern may be
always unsafe. Perhaps, we need to wait the entry is surely removed
before freeing the data.

Thanks,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


