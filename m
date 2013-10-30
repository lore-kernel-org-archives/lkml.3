Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3J3Qlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:41:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab3J3Ql3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:41:29 -0400
Message-ID: <5271368E.6060802@redhat.com>
Date: Wed, 30 Oct 2013 17:40:46 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com> <CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com> <52700C24.9050001@linux.vnet.ibm.com> <CA+55aFzqumDX8hRyC4avbpA2g_RRb28ZPYk=_-4atGJ=67Zu1A@mail.gmail.com> <52711121.9030606@linux.vnet.ibm.com> <20131030142359.GA32196@kroah.com> <5271284A.6000002@linux.vnet.ibm.com> <527129D4.3010308@redhat.com> <20131030155930.GA23433@kroah.com> <52712EE9.9050402@redhat.com> <20131030162342.GA21211@kroah.com>
In-Reply-To: <20131030162342.GA21211@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/10/2013 17:23, Greg KH ha scritto:
>> > static inline struct dentry *debugfs_create_dir(const char *name,
>> >                                                 struct dentry *parent)
>> > {
>> >         return ERR_PTR(-ENODEV);
>> > }
>> > 
>> > which would oops a lot of the current callers.
> It will oops?  Really?  Where?  That shouldn't happen at all.

Doh, it obviously won't because the bogus pointer value will never be
dereferenced by the dummy debugfs_create_file.

>> > Very few places use the currently correct idiom
>> > 
>> > 	if (IS_ERR(root) || !root)
>> > 
>> > but it's very ugly...  Perhaps debugfs_create_dir *should* return an
>> > error-valued pointer after all.
> Or just don't care about the return value, and all will work out just
> fine, right?

Debugfs files would then be created in the debugfs root, which is not nice.

        /* If the parent is not specified, we create it in the root.
         * We need the root dentry to do this, which is in the super 
         * block. A pointer to that is in the struct vfsmount that we
         * have around.
         */
        if (!parent)
                parent = debugfs_mount->mnt_root;

This is all documented right:

/**
 * debugfs_create_file - create a file in the debugfs filesystem
 * ...
 * This function will return a pointer to a dentry if it succeeds.  This
 * pointer must be passed to the debugfs_remove() function when the file is
 * to be removed (no automatic cleanup happens if your module is unloaded,
 * you are responsible here.)  If an error occurs, %NULL will be returned.
 *
 * If debugfs is not enabled in the kernel, the value -%ENODEV will be
 * returned.
 */

so I guess it's just part of the API.

Paolo
