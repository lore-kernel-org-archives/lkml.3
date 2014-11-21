Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbaKUQld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:41:33 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:43277 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368AbaKUQlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:41:31 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrW-RkhKa4n7X1HoPgmSuLV4V8YQ=FaSYVJ1YsHS=pJCSQ@mail.gmail.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
 <1416546149-24799-7-git-send-email-gregkh@linuxfoundation.org> <CALCETrW-RkhKa4n7X1HoPgmSuLV4V8YQ=FaSYVJ1YsHS=pJCSQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 08:41:10 -0800
Message-ID: <CALCETrXSwGfUXMcZmfdF30KJWGpSvsPTCvazTvEJVy2akksKdg@mail.gmail.com>
Subject: Re: kdbus: add node and filesystem implementation
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@zonque.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 8:35 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Nov 20, 2014 at 9:02 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> From: Daniel Mack <daniel@zonque.org>
>>
>> kdbusfs is a filesystem that will expose a fresh kdbus domain context
>> each time it is mounted. Per mount point, there will be a 'control'
>> node, which can be used to create buses. fs.c contains the
>> implementation of that pseudo-fs. Exported inodes of 'file' type have
>> their i_fop set to either kdbus_handle_control_ops or
>> kdbus_handle_ep_ops, depending on their type. The actual dispatching
>> of file operations is done from handle.c
>>
>> node.c is an implementation of a kdbus object that has an id and
>> children, organized in an R/B tree. The tree is used by the filesystem
>> code for lookup and iterator functions, and to deactivate children
>> once the parent is deactivated. Every inode exported by kdbusfs is
>> backed by a kdbus_node, hence it is embedded in struct kdbus_ep,
>> struct kdbus_bus and struct kdbus_domain.
>>
>> Signed-off-by: Daniel Mack <daniel@zonque.org>
>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>
>
>> +
>> +static struct file_system_type fs_type = {
>> +       .name           = KBUILD_MODNAME "fs",
>> +       .owner          = THIS_MODULE,
>> +       .mount          = fs_super_mount,
>> +       .kill_sb        = fs_super_kill,
>> +};
>
> Does this want something like:
>
> .fs_flags = FS_USERNS_MOUNT
>
> This design may have the annoying property that, if a namespace-based
> sandbox wants to use kdbus itself, it will need to proxy anything from
> the parent that it wants to use.
>
> Is there a good reason why individual *busses* don't show up in the
> filesystem?  If they did, maybe they could be bind-mounted or
> otherwise arranged to cross namespace boundaries.
>

Whoops.  Brainfart there -- busses do show up in the filesystem.  Does
bind-mounting them work?

--Andy
