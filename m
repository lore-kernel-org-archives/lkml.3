Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaDUQwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:52:47 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:58052 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaDUQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:52:45 -0400
Message-ID: <53554CDA.1060806@mentor.com>
Date: Mon, 21 Apr 2014 11:52:42 -0500
From: Nathan Lynch <Nathan_Lynch@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <x86@kernel.org>
CC: Kees Cook <keescook@google.com>, <luto@amacapital.net>,
        <linux-kernel@vger.kernel.org>
Subject: randomized placement of x86_64 vdso
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2014 16:52:44.0195 (UTC) FILETIME=[1DAB9730:01CF5D82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi x86/vdso people,

I've been working on adding a vDSO to 32-bit ARM, and Kees suggested I
look at x86_64's algorithm for placing the vDSO at a randomized offset
above the stack VMA.  I found that when the stack top occupies the
last slot in the PTE (is that the right term?), the vdso_addr routine
returns an address below mm->start_stack, equivalent to
(mm->start_stack & PAGE_MASK).  For instance if mm->start_stack is
0x7fff3ffffc96, vdso_addr returns 0x7fff3ffff000.

Since the address returned is always already occupied by the stack,
get_unmapped_area detects the collision and falls back to
vm_unmapped_area.  This results in the vdso being placed in the
address space next to libraries etc.  While this is generally
unnoticeable and doesn't break anything, it does mean that the vdso is
placed below the stack when there is actually room above the stack.
To me it also seems uncomfortably close to placing the vdso in the way
of downward expansion of the stack.

I don't have a patch because I'm not sure what the algorithm should
be, but thought I would bring it up as vdso_addr doesn't seem to be
behaving as intended in all cases.


Thanks,
Nathan
