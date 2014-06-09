Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbaFILLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:11:11 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48084 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaFILLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:11:09 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [fuse-devel] [PATCH 0/5] fuse: close file synchronously (v2)
From: John Muir <john@jmuir.com>
In-Reply-To: <5395906F.3070903@parallels.com>
Date: Mon, 9 Jun 2014 13:11:06 +0200
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Linux List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <1AC1913F-47DF-4707-8E27-F2E7334CE2D6@jmuir.com>
References: <20140606132541.30321.68679.stgit@localhost.localdomain> <E5474E5C-B6FC-459C-ACCE-F6871221D45E@jmuir.com> <53956730.1070302@parallels.com> <C6F7C8BC-7F62-45D9-AE9D-52CF096ACBC2@jmuir.com> <5395906F.3070903@parallels.com>
To: Maxim Patlasov <mpatlasov@parallels.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.06.09, at 12:46 , Maxim Patlasov <mpatlasov@parallels.com> wrote:

> On 06/09/2014 01:26 PM, John Muir wrote:
>> On 2014.06.09, at 9:50 , Maxim Patlasov <mpatlasov@parallels.com> wrote:
>> 
>>> On 06/06/2014 05:51 PM, John Muir wrote:
>>>> On 2014.06.06, at 15:27 , Maxim Patlasov <mpatlasov@parallels.com> wrote:
>>>> 
>>>>> The patch-set resolves the problem by making fuse_release synchronous:
>>>>> wait for ACK from userspace for FUSE_RELEASE if the feature is ON.
>>>> Why not make this feature per-file with a new flag bit in struct fuse_file_info rather than as a file-system global?
>>> I don't expect a great demand for such a granularity. File-system global "close_wait" conveys a general user expectation about filesystem behaviour in distributed environment: if you stopped using a file on given node, whether it means that the file is immediately accessible from another node.
>>> 
>> By user do you mean the end-user, or the implementor of the file-system? It seems to me that the end-user doesn't care, and just wants the file-system to work as expected. I don't think we're really talking about the end-user.
> 
> No, this is exactly about end-user expectations. Imagine a complicated heavy-loaded shared storage where handling FUSE_RELEASE in userspace may take a few minutes. In close_wait=0 case, an end-user who has just called close(2) has no idea when it's safe to access the file from another node or even when it's OK to umount filesystem.

I think we're saying the same thing here from different perspectives. The end-user wants the file-system to operate with the semantics you describe, but I don't think it makes sense to give the end-user control over those semantics. The file-system itself should be implemented that way, or not, or per-file

If it's a read-only file, then does this not add the overhead of having the kernel wait for the user-space file-system process to respond before closing it. In my experience, there is actually significant cost to the kernel to user-space messaging in FUSE when manipulating thousands of files.

> 
>> 
>> The implementor of a file-system, on the other hand, might want the semantics for close_wait on some files, but not on others. Won't there be a performance impact? Some distributed file-systems might want this on specific files only. Implementing it as a flag on the struct fuse_file_info gives the flexibility to the file-system implementor.
> 
> fuse_file_info is an userspace structure, in-kernel fuse knows nothing about it. In close_wait=1 case, nothing prevents a file-system implementation from ACK-ing FUSE_RELEASE request immediately (for specific files) and schedule actual handling for future processing.

Of course you know I meant that you'd add another flag to both fuse_file_info, and in the kernel equivalent for those flags which is struct fuse_open_out -> open_flags. This is where other such per file options are specified such as whether or not to keep the in-kernal cache for a file, whether or not to allow direct-io, and whether or not to allow seek.

Anyway, I guess you're the one doing all the work on this and if you have a particular implementation that doesn't require such fine-grained control, and no one else does then it's up to you. I'm just trying to show an alternative implementation that gives the file-system implementor more control while keeping the ability to meet user expectations.

Regards,
 
John.

--
John Muir - john@jmuir.com
+32 491 64 22 76

