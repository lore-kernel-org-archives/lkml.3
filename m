Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3JYIbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:31:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:10452 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752378Ab3JYIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:31:44 -0400
Message-ID: <1382689893.8356.2.camel@pippen.local.home>
Subject: Re: [PATCH trace-cmd 2/5] build: Install data files without execute
 permissions
From: Steven Rostedt <rostedt@goodmis.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 25 Oct 2013 04:31:33 -0400
In-Reply-To: <1382642074-15567-3-git-send-email-seth.forshee@canonical.com>
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
	 <1382642074-15567-3-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 14:14 -0500, Seth Forshee wrote:
> diff --git a/Makefile b/Makefile
> index 1964949..2423038 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -86,7 +86,8 @@ ifeq ($(shell sh -c "python-config --includes > /dev/null 2>&1 && echo y"), y)
>  	PYTHON_PLUGINS := plugin_python.so
>  	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
>  	PYTHON_SO_INSTALL := ctracecmd.install
> -	PYTHON_PY_INSTALL := event-viewer.install tracecmd.install tracecmdgui.install
> +	PYTHON_PY_PROGS := event-viewer.install
> +	PYTHON_PY_LIBS := tracecmd.install tracecmdgui.install
>  endif
>  endif # NO_PYTHON
>  
> @@ -506,21 +507,32 @@ define do_install
>  	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
>  endef
>  
> +define do_install_data
> +	$(print_install)				\
> +	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
> +		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
> +	fi;						\
> +	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
> +endef
> +
>  $(PLUGINS_INSTALL): %.install : %.so force
> -	$(Q)$(call do_install,$<,$(plugin_dir_SQ))
> +	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
>  
>  install_plugins: $(PLUGINS_INSTALL)
>  
>  $(PYTHON_SO_INSTALL): %.install : %.so force
> -	$(Q)$(call do_install,$<,$(python_dir_SQ))
> +	$(Q)$(call do_install_data,$<,$(python_dir_SQ))

Hmm, I never realized that shared libraries are not suppose to be
executable. At first I thought this was a mistake, but looking at other
shared libraries on my system, it seems a lot are not executable
(although many are, but those may also be made by people like myself who
thought there were suppose to be).

Thanks,

-- Steve

>  
> -$(PYTHON_PY_INSTALL): %.install : %.py force
> +$(PYTHON_PY_PROGS): %.install : %.py force
>  	$(Q)$(call do_install,$<,$(python_dir_SQ))
>  
> +$(PYTHON_PY_LIBS): %.install : %.py force
> +	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
> +
>  $(PYTHON_PY_PLUGINS): %.install : %.py force
> -	$(Q)$(call do_install,$<,$(plugin_dir_SQ))
> +	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
>  
> -install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_INSTALL) $(PYTHON_PY_PLUGINS)
> +install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_PROGS) $(PYTHON_PY_LIBS) $(PYTHON_PY_PLUGINS)
>  
>  install_cmd: all_cmd install_plugins install_python
>  	$(Q)$(call do_install,trace-cmd,$(bindir_SQ))


