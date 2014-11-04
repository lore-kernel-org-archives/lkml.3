Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaKDPAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:00:42 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:37044 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaKDPAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <20141104134633.GA14014@htj.dyndns.org>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-8-git-send-email-adityakali@google.com> <87y4rvrakn.fsf@x220.int.ebiederm.org>
 <CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA@mail.gmail.com> <20141104134633.GA14014@htj.dyndns.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Nov 2014 07:00:15 -0800
Message-ID: <CALCETrUggQCJyxsTWRNrjt3GM=R0VMU6RjMkU1aw3YUNMx1xEw@mail.gmail.com>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init cgroupns
To: Tejun Heo <tj@kernel.org>
Cc: Aditya Kali <adityakali@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 5:46 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Aditya.
>
> On Mon, Nov 03, 2014 at 02:43:47PM -0800, Aditya Kali wrote:
>> I agree that this is effectively bind-mounting, but doing this in kernel
>> makes it really convenient for the userspace. The process that sets up the
>> container doesn't need to care whether it should bind-mount cgroupfs inside
>> the container or not. The tasks inside the container can mount cgroupfs on
>> as-needed basis. The root container manager can simply unshare cgroupns and
>> forget about the internal setup. I think this is useful just for the reason
>> that it makes life much simpler for userspace.
>
> If it's okay to require userland to just do bind mounting, I'd be far
> happier with that.  cgroup mount code is already overcomplicated
> because of the dynamic matching of supers to mounts when it could just
> have told userland to use bind mounting.  Doesn't the host side have
> to set up some of the filesystem layouts anyway?  Does it really
> matter that we require the host to set up cgroup hierarchy too?
>

Sort of, but only sort of.

You can create a container by unsharing namespaces, mounting
everything, and then calling pivot_root.  But this is unpleasant
because of the strange way that pid namespaces work -- you generally
have to fork first, so this gets tedious.  And it doesn't integrate
well with things like fstab or other container-side configuration
mechanisms.

It's nicer if you can unshare namespaces, mount the bare minimum,
pivot_root, and let the contained software do as much setup as
possible.

--Andy
