Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaDCTB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:01:29 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:33457 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaDCTBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:01:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAOS58YMckmoCocguf9BC_Wxbn3D2Rx3MArhgozO9qCj4g=5aDw@mail.gmail.com>
References: <20140403164911.GE24119@htj.dyndns.org>
	<CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com>
	<CA+55aFwBm202pchEH9A6vbJVdar9-T35pBF44cCt7FNjmno9sQ@mail.gmail.com>
	<CAOS58YMckmoCocguf9BC_Wxbn3D2Rx3MArhgozO9qCj4g=5aDw@mail.gmail.com>
Date: Thu, 3 Apr 2014 12:01:23 -0700
X-Google-Sender-Auth: 2KPzw29RVff1xMSG3Okx4YFCAEE
Message-ID: <CA+55aFw2+VKojzoF2aDaruOMKHikTO8J0HeK9DoDLZr+HqTWbg@mail.gmail.com>
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Extending the participants list a bit ]

On Thu, Apr 3, 2014 at 11:34 AM, Tejun Heo <tj@kernel.org> wrote:
> On the road so sending from phone. Iirc the param is necessary to
> distinguishe when a new sb is created so that it can be put properly later.
> I think cgroup is leaking super ref now and li was planning to send a fix
> once things are merged.

So as far as I can tell, cgroup is fine, because the superblock itself
is properly refcounted by the mounting code. It's the magic hidden
"namespace" pointer that isn't properly refcounted, because that
stupid sucker is typeless and depends on the namespace kind (so to
drop a namespace pointer you need to pass in not just the pointer, but
also the right "KOBJ_NS_TYPE_xxx" type, which right now is always
KOBJ_NS_TYPE_NET).

Quite frankly, the whole "let's make the 'ns' pointer be a 'const void
*' and rely on people passing the right type along" is some seriously
crazy sh*t. Couldn't we force it to be a pointer to a union where the
first member is the type, so that

 (a) we don't use "const void *" that casts silently a bit too well to
*anything* (the "const" helps a bit, thankfully)

 (b) we don't have to pass both pointer and type along, we can just
pass the pointer, and the type can be looked up from it?

Hmm? It *looks* like the only thing that generates namespace pointers
right now is "net_namespace()", which just returns a "struct net *".
Could we just add that "type" as the first member of that struct, and
make the rule be (for any future namespaces) that the first member has
to be an "int type" field?

I might well have missed some other source that generates namespace
pointers, but it really looks like right now all those namespace()
things end up calling ->class->namespace(), and the only class that
then implements a namespace pointer function is networking and that
"net_namespace()". And I don't *think* that the networking code would
mind having that "int type" at the head of the "struct net" it uses.

The reason I'd like to have the type accessible from the pointer is
that then we *could* use that type to index into the namespace ops,
and grab reference counts etc. Instead of having that "const void *ns"
pointer that you can't do anything about, and have to expect that the
caller (that knows the type of it) will do the right thing wrt
refcounting etc.

Is there something I'm missing?

            Linus
