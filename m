Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaJBQBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:01:40 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:49160 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaJBQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:01:39 -0400
MIME-Version: 1.0
In-Reply-To: <20141002142503.GA13203@node.dhcp.inet.fi>
References: <20140930164047.GA18354@redhat.com>
	<CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>
	<20140930182059.GA24431@redhat.com>
	<CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>
	<alpine.LSU.2.11.1410010031070.1902@eggly.anvils>
	<CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
	<CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>
	<CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>
	<542C7B5E.2020000@oracle.com>
	<CA+55aFy7Y+pmhyEHTJg=K8gLKzLHxzz6j9FBJMt7_Fazfong6g@mail.gmail.com>
	<20141002142503.GA13203@node.dhcp.inet.fi>
Date: Thu, 2 Oct 2014 09:01:38 -0700
X-Google-Sender-Auth: rqW9j05c6u66Hif3SN14ZwI0N9g
Message-ID: <CA+55aFx691Ymqnw1oBUGJdsKsSrKvJ9sVVjYRwKd8QEhTpos3A@mail.gmail.com>
Subject: Re: pipe/page fault oddness.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 7:25 AM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> I don't see what prevents the code to make zero page writable here.
> We need at least pmd = pmd_wrprotect(pmd) before set_pmd_at();

Do we? If it's the zero page, it had better be an anonymous mapping,
and vm_page_prot had better not be writable.

Anonymous pages don't _start_ out writable, we explicitly make them so
with code like

        if (vma->vm_flags & VM_WRITE)
                entry = pte_mkwrite(pte_mkdirty(entry));

so it should be fine to just use "pmd_modify(pmd, vma->vm_page_prot);" directly.

But hey, this is the kind of thing that maybe I'm missing something on..

              Linus
