Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaFIKqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:46:12 -0400
Received: from relay.parallels.com ([195.214.232.42]:43386 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbaFIKqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:46:10 -0400
Message-ID: <5395906F.3070903@parallels.com>
Date: Mon, 9 Jun 2014 14:46:07 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: John Muir <john@jmuir.com>
CC: Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Linux List <linux-kernel@vger.kernel.org>
Subject: Re: [fuse-devel] [PATCH 0/5] fuse: close file synchronously (v2)
References: <20140606132541.30321.68679.stgit@localhost.localdomain> <E5474E5C-B6FC-459C-ACCE-F6871221D45E@jmuir.com> <53956730.1070302@parallels.com> <C6F7C8BC-7F62-45D9-AE9D-52CF096ACBC2@jmuir.com>
In-Reply-To: <C6F7C8BC-7F62-45D9-AE9D-52CF096ACBC2@jmuir.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.24.252]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 01:26 PM, John Muir wrote:
> On 2014.06.09, at 9:50 , Maxim Patlasov <mpatlasov@parallels.com> wrote:
>
>> On 06/06/2014 05:51 PM, John Muir wrote:
>>> On 2014.06.06, at 15:27 , Maxim Patlasov <mpatlasov@parallels.com> wrote:
>>>
>>>> The patch-set resolves the problem by making fuse_release synchronous:
>>>> wait for ACK from userspace for FUSE_RELEASE if the feature is ON.
>>> Why not make this feature per-file with a new flag bit in struct fuse_file_info rather than as a file-system global?
>> I don't expect a great demand for such a granularity. File-system global "close_wait" conveys a general user expectation about filesystem behaviour in distributed environment: if you stopped using a file on given node, whether it means that the file is immediately accessible from another node.
>>
> By user do you mean the end-user, or the implementor of the file-system? It seems to me that the end-user doesn't care, and just wants the file-system to work as expected. I don't think we're really talking about the end-user.

No, this is exactly about end-user expectations. Imagine a complicated 
heavy-loaded shared storage where handling FUSE_RELEASE in userspace may 
take a few minutes. In close_wait=0 case, an end-user who has just 
called close(2) has no idea when it's safe to access the file from 
another node or even when it's OK to umount filesystem.

>
> The implementor of a file-system, on the other hand, might want the semantics for close_wait on some files, but not on others. Won't there be a performance impact? Some distributed file-systems might want this on specific files only. Implementing it as a flag on the struct fuse_file_info gives the flexibility to the file-system implementor.

fuse_file_info is an userspace structure, in-kernel fuse knows nothing 
about it. In close_wait=1 case, nothing prevents a file-system 
implementation from ACK-ing FUSE_RELEASE request immediately (for 
specific files) and schedule actual handling for future processing.

Thanks,
Maxim
