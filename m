Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3HEWDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:03:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:21922 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab3HEWDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="342111474"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: x86: Clean up asmlinkage use
Date: Mon,  5 Aug 2013 15:02:34 -0700
Message-Id: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchkit makes the use of asmlinkage consistent in arch/x86
Originally arch/x86 was (mostly) fully annotated with asmlinkage, but 
this has bitrotted over time.

These changes were originally part of my LTO patchkit. In the interest
of making it smaller, I'm posting them separately, as they can be
considered cleanups.

By itself they do not improve anything in the existing kernel,
except for making things more consistent.

They may be useful for other global compile time instrumentation tools
to indicate clearly that some function/variable can be changed
outside their view.

---

The goal is to mark every function or variable that can be called
from assembler. asmlinkage on 32bit includes regparm(0) so changes
semantics. Since I didn't want to audit every caller and make
this patchkit a nop by itself, I did not add new asmlinkage
to 32bit functions that take parameters. So no existing function
switches from regparm(3) to (0).

Instead every function with parameter (and variables) becomes
__visible. This is roughly equivalent now to the old "asmregparm"
(which was removed some time ago), except it also works for 
variables.

So in summary the changes are:
- Mark every function without arguments (or 64bit only) 
that is used by assembler asmlinkage
- Mark every function with parameters or variables 
that is used by assembler __visible.

I also included a few related fixes with inline assembler
and a type fix for the syscall table.

