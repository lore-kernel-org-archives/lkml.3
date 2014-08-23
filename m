Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaHWULm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 16:11:42 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42154 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaHWULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 16:11:41 -0400
Date: Sun, 24 Aug 2014 00:11:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
 added to -mm tree
Message-ID: <20140823201137.GK25918@moon>
References: <20140822192241.GA26512@redhat.com>
 <20140822201550.GA25918@moon>
 <20140823115302.GA27587@redhat.com>
 <20140823122214.GF25918@moon>
 <20140823131412.GA31685@redhat.com>
 <20140823133001.GA966@redhat.com>
 <20140823141820.GG25918@moon>
 <20140823153222.GA6559@redhat.com>
 <20140823163322.GI25918@moon>
 <20140823192915.GA27507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823192915.GA27507@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 09:29:15PM +0200, Oleg Nesterov wrote:
> On 08/23, Cyrill Gorcunov wrote:
> >
> > On Sat, Aug 23, 2014 at 05:32:22PM +0200, Oleg Nesterov wrote:
> > >
> > > And btw, where do you see RLIMIT_STACK in do_shmat() ?
> >
> > Indirectly, though start_stack pointer. We assign it in setup_arg_pages taking into
> > account RLIMIT_STACK value, then do_shmat operates with start_stack pointer,
> > thus when we setup some new value into start_stack we at least should
> > not exceed old RLIMIT_STACK?
> 
> Still can't understand how do_shmat() connects to RLIMIT_STACK, even
> indirectly. setup_arg_pages() obviously uses RLIMIT_STACK, but with or
> without the patch I sent do_shmat() behaviour does not depend on
> RLIMIT_STACK at all.

setup_arg_pages sets up start_stack member and obeys RLIMIT_STACK limit
so if there were some rlimit set the start_stack will point to space
allocated with known size, then do_shmat takes start_stack and checks
if there space left. So initial value of start_stack is limited to
rlimit setting. When setup_arg_pages is called the start_stack
has rlimit constrain, so it looks to me pretty natural to do the
same in prctl, no?

> > > > arg_start, arg_end, env_start, env_end
> > > >        really point to existing VMAs, strictly speaking the probgram can unmap
> > > >        all own VMAs except executable one and continue running without problem
> > > >        but this is not that practical I think and at first iteration I prefer
> > > >        more severe tests here on VMAs
> > >
> > > But, again, for what? There are only used to report this info via /proc/.
> >
> > Because it's close to how loading elf proceeds. This prctl is like emulating
> > micro-elf loader ;) Indeed there is no problem for kernel if all these members
> > are pointing to some already umapped VMAs,
> 
> Yes. And whatever checks you add into prctl(), an application can simply
> do mmap() before prctl() just to fool it, and unmap (say) arg_start right
> after that.

yes it can, but prctl on itsown actually not much usefull until you need
to mimic "another program" procfs output like we do in criu :)

> > but earlier we required cap-sysadmin
> > to be grated so that if someone calls for this prctl he must be knowing what
> > he is doing, and if some other unpredicted change in kernel code cause this
> > prctl to panic the kernel such action could be initiated by sysadmin only,
> > not regular user. Now I've released the security requirement so I thought
> > let be more paranoid and require all VMAs to present, all rlimits to be
> > in good shape and such even if the members we're modifying are used for
> > procfs statistics output mostly, we always have a way to relax this tests
> > but not the reverse. That was the main idea ;)
> 
> Following this logic you should also verify that KSTK_ESP(group_leader)
> falls into ->start_stack area or return an error otherwise.

And probably I should, I'll re-check.

> 
> As for elf loader, of course it sets ->start_stack/etc correctly and they
> can't point to nowehere, but this is only because it actually creates these
> segments. And I guess the c/r tools should do this "correctly" too, but
> prctl() itself can never verify this.
> 
> OK, lets look at this from another angle. Suppose that an application switches
> to another stack and unmaps ->start_stack area. Now, how are you going to
> restore it correctly if ->start_stack points to nowhere? Are you going
> to "fix" ->start_stack? I do not think this would be correct. Or, are you
> going to create the additional vma just to make prctl() happy?

Actually all the programs we were c/r'ing are "normal" ones who doesn't
mangle own contents but I fear yes, with current approach if some vma's
are missing prctl refuse to proceed. Oleg, I'm cooking the patch which
addresses all your comments and relaxes the restrictions I simply need
once again grep all members to be sure it's safe. Hopefully I'll finish
tomorrow and show the patch, still if there some other concerns please
notify me I'm happy to address any of them!
