Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaJPMbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:31:33 -0400
Received: from thoth.sbs.de ([192.35.17.2]:59163 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaJPMbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:31:32 -0400
Message-ID: <543FBA9E.6070704@siemens.com>
Date: Thu, 16 Oct 2014 14:31:26 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Daniel Wagner <daniel.wagner@bmw-carit.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v0] scripts/gdb: Use a generator instead of iterator for
 task list
References: <1412841839-24537-1-git-send-email-daniel.wagner@bmw-carit.de> <1412841839-24537-2-git-send-email-daniel.wagner@bmw-carit.de>
In-Reply-To: <1412841839-24537-2-git-send-email-daniel.wagner@bmw-carit.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-09 10:03, Daniel Wagner wrote:
> The iterator does not return any task_struct from the thread_group list
> because the first condition in the 'if not t or ...' will only be the
> first time None.
> 
> Instead of keeping track of the state ourself in the next() function,
> we fall back using Python's generator.
> 
> Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
> Cc: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  scripts/gdb/linux/tasks.py | 50 +++++++++++++++++++---------------------------
>  1 file changed, 20 insertions(+), 30 deletions(-)
> 
> diff --git a/scripts/gdb/linux/tasks.py b/scripts/gdb/linux/tasks.py
> index 0008e75..e2037d9 100644
> --- a/scripts/gdb/linux/tasks.py
> +++ b/scripts/gdb/linux/tasks.py
> @@ -18,38 +18,28 @@ from linux import utils
>  
>  task_type = utils.CachedType("struct task_struct")
>  
> -
> -class TaskList:
> -    def __init__(self):
> -        global task_type
> -        self.task_ptr_type = task_type.get_type().pointer()
> -        self.init_task = gdb.parse_and_eval("init_task")
> -        self.curr_group = self.init_task.address
> -        self.curr_task = None
> -
> -    def __iter__(self):
> -        return self
> -
> -    def __next__(self):
> -        t = self.curr_task
> -        if not t or t == self.curr_group:
> -            self.curr_group = \
> -                utils.container_of(self.curr_group['tasks']['next'],
> -                                   self.task_ptr_type, "tasks")
> -            if self.curr_group == self.init_task.address:
> -                raise StopIteration
> -            t = self.curr_task = self.curr_group
> -        else:
> -            self.curr_task = \
> -                utils.container_of(t['thread_group']['next'],
> -                                   self.task_ptr_type, "thread_group")
> -        return t
> -
> -    def next(self):
> -        return self.__next__()
> +def task_lists():
> +    global task_type
> +    task_ptr_type = task_type.get_type().pointer()
> +    init_task = gdb.parse_and_eval("init_task").address
> +    t = g = init_task
> +
> +    while True:
> +        while True:
> +            yield t
> +
> +            t = utils.container_of(t['thread_group']['next'],
> +                                   task_ptr_type, "thread_group")
> +            if t == g:
> +                break
> +
> +        t = g = utils.container_of(g['tasks']['next'],
> +                                   task_ptr_type, "tasks")
> +        if t == init_task:
> +            return
>  
>  def get_task_by_pid(pid):
> -    for task in TaskList():
> +    for task in task_lists():
>          if int(task['pid']) == pid:
>              return task
>      return None
> 

Thanks for the fix (and the nice simplification), added to my queue.
I'll repost the whole series ASAP.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
